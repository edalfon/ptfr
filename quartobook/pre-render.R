#print("THIS IS WD")
#print(getwd())

# https://github.com/quarto-dev/quarto-cli/discussions/10535
# https://github.com/quarto-dev/quarto-cli/discussions/10681

# quarto does not seem to run the .Rprofile in the main project root,
# when rendering a quarto subproject. Even if you change the execute-dir
# to the project root, it still does not run the .Rprofile there.
# So we copy the .Rprofile to the quarto subproject root.

fs::file_copy("../.Rprofile", ".Rprofile", overwrite = TRUE)
