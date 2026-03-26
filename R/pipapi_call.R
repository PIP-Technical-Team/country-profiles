# library(groundhog)

# remotes::install_github("PIP-Technical-Team/wbpip@DEV")
# remotes::install_github("PIP-Technical-Team/pipapi@DEV")

library(fastverse)
library(pipapi)
## Set for parallel processing
## Keep half cores for processes
## And the other half for sending parallel requests

# remotes::install_github("PIP-Technical-Team/pipapi@DEV")

data_dir <- Sys.getenv("PIPAPI_DATA_ROOT_FOLDER_LOCAL") |>
  fs::path()

version <- "^2026"

lkups <- pipapi::create_versioned_lkups(
  data_dir = data_dir,
  vintage_pattern = version
)
povlines <- .01 |>
  c(seq(from = 0.05, to = 10, by = 0.05), seq(from = 11, to = 21, by = 1), 21.7)


# povlines <- povlines[1:10]

# Run by LInes with Future ---------
#
# poss_pip <- purrr::possibly(pipapi::pip,
#                             otherwise = pipapi::empty_response)

dl_pip_pov <- lapply(rev(lkups$versions), \(l) {
  lk <- lkups$versions_paths[[l]]
  pipapi::pip(povline = povlines, lkup = lk, fill_gaps = FALSE)
})

names(dl_pip_pov) <- lkups$versions

if (require(pushoverr)) {
  pushoverr::pushover("Done with pill calls")
}


# save in dta and fst ---------
root_dir <- "//wbgfscifs01/gtsd/06.share/PIP/country_profiles"
for (x in rev(lkups$versions)) {
  # file name
  out_dir <- fs::path(root_dir, x) |>
    fs::dir_create()
  ppp <- sub("[^_]+_([^_]+).+", "\\1", x)
  file_name <-
    fs::path(out_dir, "pip_all_lines", ext = "dta")

  # Bind and append
  dl_pip_pov[[x]] |>
    haven::write_dta(file_name)
}


pushoverr::pushover("Done with poverty lines for country profiles")
