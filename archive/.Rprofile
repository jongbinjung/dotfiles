# Only display four digits
options(digits = 4)

# Set default repo to CA
local({
  r <- getOption("repos")
  # r["CRAN"] <- "https://cran.cnr.berkeley.edu/"
  r["CRAN"] <- "https://ftp.osuosl.org/pub/cran/"
  options(repos = r)
})

q <- function (save = "no", ...) {
  quit(save = save, ...)
}

if (interactive()){
  # Suggested libraries:
  library(colorout)
  options(setWidthOnResize = TRUE)

  # Use text based web browser to navigate through R docs after help.start():
  # if (Sys.getenv("NVIMR_TMPDIR") != "")
      # options(browser = function(u)
              # .C("nvimcom_msg_to_nvim",
                 # paste0('StartTxtBrowser("w3m", "', u, '")')))
  options(browser = "reload_html")
}
