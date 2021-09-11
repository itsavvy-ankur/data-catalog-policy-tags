terraform {
  backend "gcs" {
    bucket = "data-catalog-demo-323514-tfstate"
    prefix = "terraform/state/rnd"
  }
}

resource "google_data_catalog_taxonomy" "basic_taxonomy" {
  project      = var.project_id
  provider     = google-beta
  region       = "us"
  display_name = "SensitiveData-TF"
  description  = "A collection of policy tags for sensitive data"
}

resource "google_data_catalog_policy_tag" "pii_policy_tag" {
  provider     = google-beta
  taxonomy     = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name = "PII"
  description  = "A policy tag normally associated with PII data"
}

resource "google_data_catalog_policy_tag" "pii_name_policy_tag" {
  provider          = google-beta
  taxonomy          = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name      = "name"
  description       = "User's first name"
  parent_policy_tag = google_data_catalog_policy_tag.pii_policy_tag.id
}

resource "google_data_catalog_policy_tag" "pii_email_policy_tag" {
  provider          = google-beta
  taxonomy          = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name      = "email"
  description       = "User's email"
  parent_policy_tag = google_data_catalog_policy_tag.pii_policy_tag.id
}


resource "google_data_catalog_policy_tag" "non_pii_policy_tag" {
  provider     = google-beta
  taxonomy     = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name = "Non PII"
  description  = "A policy tag normally associated with non PII sensitive data"
}


resource "google_data_catalog_policy_tag" "non_pii_uspa5_policy_tag" {
  provider          = google-beta
  taxonomy          = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name      = "uspa5"
  description       = "uspa5"
  parent_policy_tag = google_data_catalog_policy_tag.non_pii_policy_tag.id
}


###############
#IAM Policy - 
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_catalog_policy_tag_iam#google_data_catalog_policy_tag_iam_policy
###############

data "google_iam_policy" "iam_member_policy" {
  binding {
    role    = "roles/datacatalog.categoryFineGrainedReader"
    members = var.policy_members
  }
}

resource "google_data_catalog_policy_tag_iam_policy" "pii_name_iam_policy" {
  provider    = google-beta
  policy_tag  = google_data_catalog_policy_tag.pii_name_policy_tag.name
  policy_data = data.google_iam_policy.iam_member_policy.policy_data
}