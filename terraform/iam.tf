# Service Account 

resource "google_service_account" "transform_cf_sa" {
  project   = var.project_id
  account_id   = var.cloud_function_sa_name
  display_name = "The service account used by the Cloud Function."
}

# Cloud Function Mixer
data "google_iam_policy" "cloud_mixer_policy" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${var.terraform_provisioning_sa_name}@${var.project_id}.iam.gserviceaccount.com"
    ]
  }
}

resource "google_service_account_iam_policy" "transform_cloudfunction_policy_binding" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.cloud_function_sa_name}@${var.project_id}.iam.gserviceaccount.com"
  policy_data        = data.google_iam_policy.cloud_mixer_policy.policy_data
  depends_on = [
    google_service_account.transform_cf_sa
  ]
}
