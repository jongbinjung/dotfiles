if(interactive()){
   # Suggested libraries:
   library(setwidth)

   # Use text based web browser to navigate through R docs after help.start():
   if(Sys.getenv("NVIMR_TMPDIR") != "")
       options(browser = function(u) .C("nvimcom_msg_to_nvim",
                                        paste0('StartTxtBrowser("w3m", "', u, '")')))
}

# Only display two digits
options(digits=2)
