data "archive_file" "cf_sources" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "../src.zip"
}

resource "google_storage_bucket" "archive_bucket" {
  project       = var.project_id
  name          = "${var.project_id}-archive"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  storage_class = "STANDARD"
}

resource "google_storage_bucket_object" "cf_target_zip" {
  name   = "archive/src.zip"
  bucket = google_storage_bucket.archive_bucket.name
  source = "../src.zip"
  depends_on = [
    google_storage_bucket.archive_bucket
  ]
}

resource "google_cloudfunctions_function" "private_vpc_cf" {
  project   = var.project_id
  region    = var.region
  name        = var.cf_name
  description = "Hello world function."
  runtime     = "python38"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.archive_bucket.name
  source_archive_object = google_storage_bucket_object.cf_target_zip.name
  trigger_http          = true
  entry_point           = "hello_world"

  service_account_email = "${var.cloud_function_sa_name}@${var.project_id}.iam.gserviceaccount.com"

  vpc_connector = "projects/${var.project_id}/locations/${var.region}/connectors/${var.connector_name}"

  depends_on = [
    module.serverless_connector,
    google_service_account_iam_policy.transform_cloudfunction_policy_binding
  ]

}
