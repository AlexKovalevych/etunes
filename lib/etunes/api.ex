defmodule Etunes.Api do
    import ExPrintf

    def access_token_url do
        app_id = Application.get_env(:etunes, :app_id)
        api_version = Application.get_env(:etunes, :api_version)
        sprintf("https://oauth.vk.com/authorize?client_id=%s&display=page&redirect_uri=http://vk.com/callback&scope=audio&response_type=token&v=%s", [app_id, api_version])
    end
end
