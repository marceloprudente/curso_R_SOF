# Função para editar nomes
adequar_nomes<- function(x){
  require(stringr)
  require(stringi)
  x = stri_trans_general(x, "Latin-ASCII")
  x = tolower(x)
  x = str_replace_all(x, "[[:punct:][:space:]]", "_")
}