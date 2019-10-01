provider "tfe" {
  hostname = var.hostname
  token    = var.token
}

resource "tfe_team" "developers" {
  name         = "${var.use_case_name}-Devs"
  organization = var.org
}

resource "tfe_team" "ops" {
  name         = "${var.use_case_name}-Ops"
  organization = var.org
}

resource "tfe_team" "network" {
  name         = "Networking"
  organization = var.org
}

resource "tfe_team" "security" {
  name         = "Security"
  organization = var.org
}

resource "tfe_team" "security_admins" {
  name         = "SecurityAdmins"
  organization = var.org
}

resource "tfe_team_member" "dev-user" {
  team_id  = tfe_team.developers.id
  username = "dev-user"
}

resource "tfe_team_member" "ops-user" {
  team_id  = tfe_team.ops.id
  username = "ops-user"
}

resource "tfe_team_member" "net-user" {
  team_id  = tfe_team.network.id
  username = "net-user"
}

resource "tfe_team_member" "sec-user" {
  team_id  = tfe_team.security.id
  username = "sec-user"
}

resource "tfe_team_member" "sec-admin" {
  team_id  = tfe_team.security_admins.id
  username = "sec-admin"
}

resource "tfe_team_access" "development-dev" {
  access       = "write"
  team_id      = tfe_team.developers.id
  workspace_id = tfe_workspace.development.id
}

resource "tfe_team_access" "staging-dev" {
  access       = "write"
  team_id      = tfe_team.developers.id
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_team_access" "production-dev" {
  access       = "read"
  team_id      = tfe_team.developers.id
  workspace_id = tfe_workspace.production.id
}

resource "tfe_team_access" "development-ops" {
  access       = "write"
  team_id      = tfe_team.ops.id
  workspace_id = tfe_workspace.development.id
}

resource "tfe_team_access" "staging-ops" {
  access       = "write"
  team_id      = tfe_team.ops.id
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_team_access" "production-ops" {
  access       = "write"
  team_id      = tfe_team.ops.id
  workspace_id = tfe_workspace.production.id
}

resource "tfe_team_access" "net-devs" {
  access       = "read"
  team_id      = tfe_team.developers.id
  workspace_id = tfe_workspace.network.id
}

resource "tfe_team_access" "net-ops" {
  access       = "read"
  team_id      = tfe_team.ops.id
  workspace_id = tfe_workspace.network.id
}

resource "tfe_team_access" "net-net" {
  access       = "write"
  team_id      = tfe_team.network.id
  workspace_id = tfe_workspace.network.id
}

resource "tfe_team_access" "sec-sec" {
  access       = "write"
  team_id      = tfe_team.security.id
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_team_access" "secadmins-sec" {
  access       = "admin"
  team_id      = tfe_team.security_admins.id
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_team_access" "net-secadmins" {
  access       = "admin"
  team_id      = tfe_team.security_admins.id
  workspace_id = tfe_workspace.network.id
}

resource "tfe_team_access" "development-secadmins" {
  access       = "admin"
  team_id      = tfe_team.security_admins.id
  workspace_id = tfe_workspace.development.id
}

resource "tfe_team_access" "staging-secadmins" {
  access       = "admin"
  team_id      = tfe_team.security_admins.id
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_team_access" "production-secadmins" {
  access       = "admin"
  team_id      = tfe_team.security_admins.id
  workspace_id = tfe_workspace.production.id
}

resource "tfe_workspace" "development" {
  name              = "${var.use_case_name}-development"
  organization      = var.org
  auto_apply        = true
  queue_all_runs    = false
  terraform_version = "0.12.9"

  vcs_repo {
    branch         = "development"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "staging" {
  name              = "${var.use_case_name}-staging"
  organization      = var.org
  auto_apply        = true
  queue_all_runs    = true
  terraform_version = "0.12.9"

  vcs_repo {
    branch         = "staging"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "production" {
  name              = "${var.use_case_name}-production"
  organization      = var.org
  queue_all_runs    = true
  terraform_version = "0.12.9"

  vcs_repo {
    branch         = "master"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "sentinel" {
  name              = var.sentinel_workspace
  organization      = var.org
  queue_all_runs    = false
  terraform_version = "0.11.14"

  vcs_repo {
    branch         = "master"
    identifier     = var.sentinel_repo
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "network" {
  name              = var.network_workspace
  organization      = var.org
  queue_all_runs    = false
  terraform_version = "0.12.9"

  vcs_repo {
    branch         = "master"
    identifier     = var.network_repo
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_variable" "staging_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "development_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "production_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "network_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.network.id
}

resource "tfe_variable" "staging_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "development_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "production_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "network_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.network.id
}

resource "tfe_variable" "workspace_var_staging" {
  key      = "network_workspace"
  value    = var.network_workspace
  category = "terraform"

  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "workspace_var_development" {
  key      = "network_workspace"
  value    = var.network_workspace
  category = "terraform"

  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "workspace_var_production" {
  key      = "network_workspace"
  value    = var.network_workspace
  category = "terraform"

  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "org_var_production" {
  key          = "org"
  value        = var.org
  category     = "terraform"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "confirm_destroy1" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "confirm_destroy2" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "confirm_destroy3" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "confirm_destroy4" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.network.id
}

resource "tfe_variable" "confirm_destroy5" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_variable" "set_ttl1" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "set_ttl2" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "set_ttl3" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "set_ttl4" {
  key          = "WORKSPACE_TTL"
  value        = "38"
  category     = "env"
  workspace_id = tfe_workspace.network.id
}

resource "tfe_variable" "set_ttl5" {
  key          = "WORKSPACE_TTL"
  value        = "20"
  category     = "env"
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_variable" "org_var_development" {
  key          = "org"
  value        = var.org
  category     = "terraform"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "org_var_staging" {
  key          = "org"
  value        = var.org
  category     = "terraform"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "org_var_security" {
  key          = "tfe_organization"
  value        = var.org
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_variable" "environment_name_dev" {
  key          = "environment"
  value        = "dev"
  category     = "terraform"
  workspace_id = tfe_workspace.development.id
}

resource "tfe_variable" "environment_name_stage" {
  key          = "environment"
  value        = "stage"
  category     = "terraform"
  workspace_id = tfe_workspace.staging.id
}

resource "tfe_variable" "environment_name_prod" {
  key          = "environment"
  value        = "prod"
  category     = "terraform"
  workspace_id = tfe_workspace.production.id
}

resource "tfe_variable" "hostname_security" {
  key          = "tfe_hostname"
  value        = var.hostname
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_variable" "self_name_security" {
  key          = "self_name"
  value        = var.sentinel_workspace
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel.id
}

resource "tfe_variable" "use_case_security" {
  key          = "use_case_name"
  value        = var.use_case_name
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel.id
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = var.org
}

resource "tfe_team_token" "owners" {
  team_id = data.tfe_team.owners.id
}

resource "tfe_variable" "token_security" {
  key          = "tfe_token"
  value        = tfe_team_token.owners.token
  category     = "terraform"
  sensitive    = "true"
  workspace_id = tfe_workspace.sentinel.id
}

