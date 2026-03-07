oidc_clients = {
  "booklore" = {
    name = "Booklore"
    url  = "https://books.plexmox.com"
    callback_urls = [
      "https://books.plexmox.com/oauth2-callback",
      "https://books.plexmox.com/*",
    ]
    pkce_enabled = true
  }
  "outline" = {
    name = "Outline"
    url  = "https://docs.plexmox.com"
    callback_urls = [
      "https://docs.plexmox.com/auth/oidc.callback"
    ]
  }
  "grafana" = {
    name = "Grafana"
    url  = "https://grafana.plexmox.com"
    callback_urls = [
      "https://grafana.plexmox.com/login/generic_oauth"
    ]
    pkce_enabled = true
  }
  "immich" = {
    name = "Immich"
    url  = "https://immich.plexmox.com"
    callback_urls = [
      "https://immich.plexmox.com/auth/login",
      "https://immich.plexmox.com/api/oauth/mobile-redirect",
      "https://immich.plexmox.com/user-settings",
      # "app.immich:///oauth-callback",
    ]
  }
  "harbor" = {
    name = "Harbor"
    url  = "https://harbor.plexmox.com"
    callback_urls = [
      "https://harbor.plexmox.com/c/oidc/callback"
    ]
  }
  "proxmox" = {
    name          = "Proxmox"
    url           = "https://proxmox.plexmox.com"
    callback_urls = ["https://proxmox.plexmox.com"]
  }
}
