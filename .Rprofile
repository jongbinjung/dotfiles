if(interactive()){
   # Suggested libraries:
   library(colorout)
   library(setwidth)
   library(setwidth)
   library(colorout)

   # Use text based web browser to navigate through R docs after help.start():
   if(Sys.getenv("NVIMR_TMPDIR") != "")
       options(browser = function(u) .C("nvimcom_msg_to_nvim",
                                        paste0('StartTxtBrowser("w3m", "', u, '")')))

   # Work in tmp
   setwd('~/tmp')
}

# Only display four digits
options(digits=4)
