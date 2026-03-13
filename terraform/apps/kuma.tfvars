http_monitors = {
  authelia = {
    name = "Authelia"
    url  = "https://auth.plexmox.com"
    tags = ["auth"]
  }
  argo = {
    name = "ArgoCD"
    url  = "http://argo-argocd-server.argo.svc.cluster.local"
    tags = ["infra"]
  }
  booklore_auth = {
    name          = "Booklore (auth)"
    url           = "https://books.plexmox.com"
    max_redirects = 0
    status_codes  = ["302", "307"]
    tags          = ["media", "auth"]
  }
  booklore = {
    name = "Booklore (internal)"
    url  = "http://booklore.media.svc.cluster.local:9568"
    tags = ["media"]
  }
  longhorn = {
    name = "Longhorn"
    url  = "http://longhorn-frontend.longhorn-system.svc.cluster.local"
    tags = ["infra"]
  }
  longhorn_auth = {
    name          = "Longhorn (auth)"
    url           = "https://longhorn.plexmox.com"
    max_redirects = 0
    status_codes  = ["307"]
    tags          = ["infra", "auth"]
  }
  organizr = {
    name = "Organizr (external)"
    url  = "https://plexmox.com"
    tags = ["media"]
  }
  seerr = {
    name = "Seerr"
    url  = "https://overseerr.plexmox.com"
    tags = ["media"]
  }
  plex = {
    name = "Plex"
    url  = "https://plex.plexmox.com/web/index.html"
    tags = ["media"]
  }
  pocket = {
    name = "Pocket"
    url  = "https://pocket.plexmox.com"
    tags = ["auth"]
  }
  prowlarr_auth = {
    name          = "Prowlarr (auth)"
    url           = "https://plexmox.com/prowlarr"
    max_redirects = 0
    status_codes  = ["302"]
    tags          = ["media", "auth"]
  }
  prowlarr = {
    name = "Prowlarr (internal)"
    url  = "http://prowlarr.media.svc.cluster.local:9696"
    tags = ["media"]
  }
  radarr_auth = {
    name          = "Radarr (auth)"
    url           = "https://plexmox.com/radarr"
    max_redirects = 0
    status_codes  = ["302"]
    tags          = ["media", "auth"]
  }
  radarr = {
    name = "Radarr (internal)"
    url  = "http://radarr.media.svc.cluster.local:7878"
    tags = ["media"]
  }
  sonarr_auth = {
    name          = "Sonarr (auth)"
    url           = "https://plexmox.com/sonarr"
    max_redirects = 0
    status_codes  = ["302"]
    tags          = ["media", "auth"]
  }
  sonarr = {
    name = "Sonarr (internal)"
    url  = "http://sonarr.media.svc.cluster.local:8989"
    tags = ["media"]
  }
  tautulli_auth = {
    name          = "Tautulli (auth)"
    url           = "https://plexmox.com/tautulli"
    max_redirects = 0
    status_codes  = ["302"]
    tags          = ["media", "auth"]
  }
  tautulli = {
    name = "Tautulli (internal)"
    url  = "http://tautulli.media.svc.cluster.local:8181"
    tags = ["media"]
  }
  transmission_auth = {
    name          = "Transmission (auth)"
    url           = "https://plexmox.com/transmission"
    max_redirects = 0
    status_codes  = ["302"]
    tags          = ["media", "auth"]
  }
  transmission = {
    name = "Transmission (internal)"
    url  = "http://transmission.media.svc.cluster.local:9091"
    tags = ["media"]
  }
  unraid_auth = {
    name          = "Unraid (auth)"
    url           = "https://unraid.plexmox.com"
    max_redirects = 0
    status_codes  = ["307"]
    tags          = ["infra", "auth"]
  }
  proxmox_auth = {
    name          = "Proxmox (auth)"
    url           = "https://proxmox.plexmox.com"
    max_redirects = 0
    status_codes  = ["307"]
    tags          = ["infra", "auth"]
  }
  argo_auth = {
    name          = "ArgoCD (auth)"
    url           = "https://argocd.plexmox.com"
    max_redirects = 0
    status_codes  = ["307"]
    tags          = ["infra", "auth"]
  }
}

redis_monitors = {
  dragonfly = {
    name = "Dragonfly"
    url  = "redis://dragonfly.dragonfly.svc:6379"
    tags = ["db", "infra"]
  }
}

tcp_monitors = {
  unraid_nfs = {
    name = "Unraid NFS"
    host = "10.0.0.9"
    port = 2049
    tags = ["infra"]
  }
  unraid_smb = {
    name = "Unraid SMB"
    host = "10.0.0.9"
    port = 445
    tags = ["infra"]
  }
}
