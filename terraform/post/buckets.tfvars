buckets = {
  longhorn = {
    name = "longhorn"
    type = "r2"
  }
  crunchy = {
    name = "crunchy"
    type = "r2"
  }
  mariadb_r2 = {
    name = "mariadb"
    type = "r2"
  }
  books = {
    name = "books"
    type = "r2"
  }
  thesuses_state = {
    name = "thesuses-state"
    type = "r2"
  }
  longhorn_local = {
    name = "longhorn"
    type = "garage"
  }
  mariadb_local = {
    name = "mariadb"
    type = "garage"
  }
  crunchy_local = {
    name = "crunchy"
    type = "garage"
  }
  dragonfly_local = {
    name = "dragonfly"
    type = "garage"
  }
  loki_local = {
    name = "loki"
    type = "garage"
  }
  tempo_local = {
    name = "tempo"
    type = "garage"
  }
  pyroscope_local = {
    name = "pyroscope"
    type = "garage"
  }
}

r2_tokens = {
  longhorn = {
    buckets = ["longhorn"]
    write   = true
  }
  crunchy = {
    buckets = ["crunchy"]
    write   = true
  }
  mariadb = {
    buckets = ["mariadb_r2"]
    write   = true
  }
  books = {
    buckets = ["books"]
    write   = true
  }
  thesuses_state = {
    buckets = ["thesuses_state"]
    write   = true
  }
}

garage_tokens = {
  longhorn = {
    name    = "longhorn"
    buckets = ["longhorn_local"]
    write   = true
  }
  mariadb = {
    name    = "mariadb"
    buckets = ["mariadb_local"]
    write   = true
  }
  crunchy = {
    name    = "crunchy"
    buckets = ["crunchy_local"]
    write   = true
  }
  dragonfly = {
    name    = "dragonfly"
    buckets = ["dragonfly_local"]
    write   = true
  }
  loki = {
    name    = "loki"
    buckets = ["loki_local"]
    write   = true
  }
  tempo = {
    name    = "tempo"
    buckets = ["tempo_local"]
    write   = true
  }
  pyroscope = {
    name    = "pyroscope"
    buckets = ["pyroscope_local"]
    write   = true
  }
}
