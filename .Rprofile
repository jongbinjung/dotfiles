if(interactive()){
   # Suggested libraries:
   library(colorout)
   library(setwidth)

   # Use text based web browser to navigate through R docs after help.start():
   if(Sys.getenv("NVIMR_TMPDIR") != "")
       options(browser = function(u) .C("nvimcom_msg_to_nvim",
                                        paste0('StartTxtBrowser("w3m", "', u, '")')))
}

# Only display four digits
options(digits=4)

# Set default repo to CA
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.cnr.berkeley.edu/"
  options(repos = r)
})
