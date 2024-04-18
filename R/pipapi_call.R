

library(fastverse)
library(furrr)
library(progressr)


## Set for parallel processing
## Keep half cores for processes
## And the other half for sending parallel requests



# remotes::install_github("PIP-Technical-Team/pipapi@DEV")

force <- TRUE

if (!"lkups" %in% ls() || isTRUE(force)) {
  data_dir <- Sys.getenv("PIPAPI_DATA_ROOT_FOLDER_LOCAL") |>
    fs::path()
  fs::dir_ls(data_dir, recurse = FALSE)
}

version  <- "^20240326"

lkups <- pipapi::create_versioned_lkups(data_dir = data_dir,
                                        vintage_pattern = version)




# lkup <-  lkups$versions_paths$`20230328_2011_02_02_PROD`
lkup <-  lkups$versions_paths[[lkups$latest_release]]

povlines <- .01 |> 
  c(seq(from = 0.05, to = 10, by = 0.05), 
    seq(from = 11, to = 21, by = 1), 
    21.7) 

n_cores <- floor((availableCores() - 1) / 2)
plan(multisession)

povlines <- povlines[1:10]

# Run by LInes with Future ---------

poss_pip <- purrr::possibly(pipapi::pip, 
                            otherwise = pipapi::empty_response)

with_progress({
  p <- progressor(steps = length(povlines))
  
  dl_pip_pov <- future_map(povlines,
              \(pl){
                p()
                qq <- lapply(lkups$versions_paths, \(l) {
                  poss_pip(povline   = pl,
                           lkup      = l,
                           fill_gaps = FALSE)
                })
                names(qq) <- lkups$versions
              },
              .options = furrr_options(seed = TRUE)
              )
})


if (require(pushoverr)) {
  pushoverr::pushover("Done with pill calls")
}

plan(sequential)


# save in dta and fst

dt_pip_pov <- rowbind(dl_pip_pov, 
                      return =  "data.table")

fst::write_fst(dt_pip_pov, "data/pip_pov")


