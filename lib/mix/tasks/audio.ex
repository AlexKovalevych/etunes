defmodule Mix.Tasks.Audio do
    use Mix.Task
    require Logger
    import Etunes.Api
    import ExPrintf

    def run(args) do
        args
        |> OptionParser.parse
        |> elem(1)
        |> Enum.chunk(2)
        |> Enum.into(%{}, fn [key, val] -> {key, val} end)
        |> do_process
    end

    def do_process(%{"token" => token}) do
        HTTPotion.start
        HTTPoison.start
        Application.start(:inets)
        %HTTPotion.Response{body: body} = HTTPotion.get(sprintf("https://api.vk.com/method/audio.get?access_token=%s", [token]))
        path = Application.get_env(:etunes, :audio_path)
        if !File.exists?(path) do
            File.mkdir(path)
        end
        data = Poison.Parser.parse!(body)
        blocks = data["response"] |> Enum.chunk(4)
        Enum.each(blocks, fn files ->
            ParallelStream.each(files, &save_audio(&1, path)) |> Enum.into([])
        end)
    end

    def do_process(_) do
        IO.puts "Pass token to any command like: mix audio token=****"
        IO.puts "Please get access token at this url:"
        IO.puts access_token_url()
        System.halt(0)
    end

    defp save_audio(data, path) do
        name = String.replace("#{data["artist"]}-#{data["title"]} (#{to_string(data["duration"])}).mp3", "/", "\\")
        url = data["url"]
        Logger.info '#{name} (#{url})'
        path = '#{path}/#{name}'
        if !File.exists?(path) do
            response = HTTPoison.get(url, [timeout: :infinity])
            case response do
                {:ok, %HTTPoison.Response{body: body}} ->
                    File.write!(path, body)
                    info = File.stat!(path)
                    size = round(info.size / 10000) / 100
                    Logger.debug '#{name} (#{size} MB)'
                {:error, %HTTPoison.Error{reason: message}} ->
                    Logger.error '#{name} (#{message})'
            end
        end
        nil
    end
end
