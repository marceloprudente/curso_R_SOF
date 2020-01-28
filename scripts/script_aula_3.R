# Manipulação de dados com dplyr
# Lembre-se dplyr faz parte do tidyverse

## vamos limpar ambiente global
rm(list = ls())

## Qual o diretório atualmente ativo?
getwd()

## Primeiro passo: fixar diretório
## (se não for o diretório ativo)
setwd("C:/curso_r/dados")

## Segundo passo: utilizar pacotes
library(tidyverse)
library(data.table) # para fread()

## Terceiro passo: carregar dados sociais
ds <- fread("dados_sociais.csv", 
            dec = ',')

## Quarto passo passo: analisar os dados
glimpse(ds) # ver estrutura dos dados
summary(ds) # sumário dos dados

# Verbos do *dplyr*----

## filter: selecionar linhas

## apenas ano 2000
ds_2000 <- filter(ds, ano == 2000)
## apenas municipio de aracaju
ds_ara <- filter(ds, municipio == "ARACAJU")
## ou municipio de São Paulo
ds_sp <- filter(ds, municipio == "SÃO PAULO")

## ano 1991 ou 2000, estado de são paulo e esperança de vida maior que 70 anos
ds2 <- filter(ds, (ano == 2000  | ano == 1991) &
         uf == 35 & 
         esp_vida >= 70) 

## Exercício: observe o banco dados_sociais tal que:
### o ano seja igual a 2010
### a taxa de analfabetismo seja maior que a média
### o estado seja do nordeste

ds_e1<- filter(ds, ano == 2010 &
         tx_analf_15m > mean(tx_analf_15m) &
         (uf >= 20 & uf <30 ))
# verificar se selecionei NE
table(ds_e1$uf)

## filtrar texto

ds_sao<-filter(ds, grepl("São", municipio,
                 ignore.case = TRUE))

# sensível a maiúsculas e minúsculas
filter(ds, grepl("Ara", municipio))
filter(ds, grepl("Ara", municipio, ignore.case = TRUE ))


# regex
# podemos utilizar as Expressões Regulares - regex
# verificar apostila aula 3 - página 8
filter(dados_sociais, grepl("^São José de", municipio, ignore.case = TRUE))

##############################################
# select() ----

# selecionar 3 colunas
ds_select <- select(ds, ano, uf, rdpc)

# mostrar primeiras linhas
head(ds_select)

# retirar colunas
ds_select2 <- select(ds, -rdpc, - pop)
head(ds_select2)

# selecionar com base em um vetor character
nome <- c("ano", "uf", "pop")
ds_select3 <- select(ds, nome)
head(ds_select3)

# selecionar primeras colunas
# retirar variável código ibge
ds_select4 <- select(ds, ano:municipio, -cod_ibge)
head(ds_select4)

# selecionar intervalo de colunas
ds_select5 <- select(ds, 1:5)
head(ds_select5)

# selecionar cadeia, exceto 1
ds_select6 <- select(ds, ano:municipio, -cod_ibge)
head(ds_select6)

# reordenar
ds_select7 <- select(ds, 5:8, 1:4)
head(ds_select7)

ds_select8 <- select(ds, pop, everything())
head(ds_select8)

## select helpers
sihsus <- read.dbc::read.dbc("RDSE1701.dbc")
glimpse(sihsus)
summary(sihsus)

### selecionar colunas que começam com VAL
sihsus_2 <- select(sihsus, 1:5,
                   starts_with("val"))
summary(sihsus_2)

### renomear
rename(ds, ANO = ano)

#################################
#### PIPE - seu melhor amigo ----
#################################

x <- 1:20
# forma tradicional
round(log(x), 2)

# com o pipe
x %>% log() %>% round(2)

# pipe com dplyr
ds_e2 <- ds %>% 
  select(ano, uf, rdpc) %>% 
  filter(ano == 2010)

# arrange
ds_e2 <- ds %>% 
  select(ano, uf, rdpc) %>% 
  filter(ano == 2010) %>% 
  arrange(-uf)
head(ds_e2)

ds_e3 <- ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>% 
  arrange(-pop, -uf) 
head(ds_e3)


ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>% 
  arrange(-pop) %>% 
  head(10)

# mutate(): criar novas variaveis
ds_3 <- ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>%
  mutate(renda_total = rdpc * pop, 
         log_pop = log(pop),
         renda_sq = renda_total ^ 2)

## group by e summarise
esp_vida <- ds %>% 
  group_by(ano, uf) %>% 
  summarise(media = mean(esp_vida),
            mediana = median(esp_vida),
            populacao = sum(pop))

##############################
## Join(): melhor que procv ##
##############################
df1 <- tibble(letras = letters[1:8],
              num_a = 1:8 )

df2 <- tibble(letras = letters[5:12], 
              num_b = 5:12)

df3 <- tibble(LETRAS = letters[5:20], 
             num_c = 5:20)

# junção natural
mesclado1 <- inner_join(df1, df2)

# junção natural
# preferível espeficicar chave
mesclado1 <- inner_join(df1, df2, by = "letras")

# não funciona: precisa identificar chave
mesclado2 <- inner_join(df1, df3)

# funciona: identifica as chaves
mesclado2 <- inner_join(df1, df3, 
                       by = c("letras" = "LETRAS"))

# full_join()
mesclado_full <- full_join(df1, df3, 
                       by = c("letras" = "LETRAS"))
mesclado_full

# left_join()
mesclado_left <- left_join(df1, df3, 
                       by = c("letras" = "LETRAS"))
mesclado_left

# right_join()
mesclado_right <- right_join(df1, df3, 
                           by = c("letras" = "LETRAS"))
mesclado_right

# anti_join()
mesclado_anti1 <- anti_join(df1, df3, 
                           by = c("letras" = "LETRAS"))
mesclado_anti1

# modificando a posição dos bancos
mesclado_anti2 <- anti_join(df3, df1, 
                            by = c("LETRAS" = "letras"))
mesclado_anti2


#####################
## OUTRAS FUNÇÕES  ##
#####################

fies <- data.table::fread("fies_sample.csv",
                          dec = ",")

# valores duplicados
fies %>% 
  select(CO_CONTRATO_FIES) %>% 
  duplicated() %>% 
  sum()

fies %>% 
  summarise(unicos = n_distinct(CO_CONTRATO_FIES))


fies %>% 
  group_by(SG_UF) %>% 
  summarise(unicos = n_distinct(CO_CONTRATO_FIES)) %>% 
  arrange(-unicos)

# selecionar apenas contratos unicos
fies_sub <- fies %>% 
  distinct(CO_CONTRATO_FIES, .keep_all = TRUE)

# contar observações: n()
fies_sexo_raca <- fies_sub %>% 
  group_by(DS_SEXO, DS_RACA_COR) %>% 
  summarise( total = n())

# mensalidade uf
fies_sub %>% 
  group_by(SG_UF) %>% 
  summarise(media = mean(VL_MENSALIDADE, na.rm = TRUE)) %>% 
  mutate(acima_med = ifelse(media > mean(media), 1 ,0),
         ac_med2 = ifelse(media > mean(media), "Acima da média", "Abaixo da Média"), 
         ac3 = ifelse(media < 900, 1,
                      ifelse(media > 1000, 3, 2)))

# any()----
df_na <- tibble(letras = LETTERS[1:11],
                idade = c(seq(10, 80, 10), NA, NA, NA))

any(is.na(df_na))

# baixar os dados
dom <- read_csv2("C:/curso_r/dados/dados_domiciliares.csv", 
                 locale = locale(encoding = "Latin1"))

# olhar os dados
glimpse(dom)

# nome das colunas
colnames(dom)

# domicilio tem idoso
dom <- dom %>% 
  group_by(domicilio) %>% 
  mutate(dom_idoso = ifelse(any(idade >= 60), 
                            "Dom. tem idoso", "Não tem idoso"))

# quantos domicílios tem idosos
dom %>% 
  distinct(dom_idoso , .keep_all = TRUE) %>% 
  group_by(dom_idoso) %>% 
  count()

# cut() ----
# cortar as idades em intervalos de 5 anos
dom <- dom %>% 
  mutate( idade_cut = cut(idade, seq(0,100, 5)))

# cortar usando age.cat
args(age.cat)

dom <- dom %>% 
  mutate(age_cat = age.cat(idade, upper = 90, by = 5))

# paste() ----
# Irmãos Peixoto
irmaos <- c("Edgar", "Edclésia", 
            "Edmar", "Edésia", "Edésio")

# Como colocar os sobrenomes?
paste(irmaos, "Peixoto")
paste(irmaos, "Peixoto", sep = ",")
paste(irmaos, "Peixoto", sep = "")
paste0(irmaos, "Peixoto")

# uso do paste
x = 1:10
y = 51:60
paste(x, y)
paste0(x, y)
paste(x, y, sep = ".") %>% as.numeric()
paste0(x, y) %>% as.numeric()

# uso do paste no dplyr
dom <- dom %>% 
  mutate(sexo_cor = paste(sexo, "-", cor)) 

head(dom$sexo_cor)

# agrupado
dom %>% 
  group_by(sexo_cor) %>% 
  count()

# substr(): cortar dados
x = "palavra"
substr(x, 1, 1)
substr(x, 1, 2)
substr(x, 3, 4)
substr(x, 3, nchar(x))

# gsub() ----
# funcionamento do gsub
gsub("-", "@", "curso-hotmail.com")

# exemplo com números
x = c("3,8", "4,9", "5,5")
as.numeric(x)
gsub(",", ".", x) %>%  as.numeric()

# aplicando a um data.frame
dom %>% 
  mutate(sexo_cor2 = gsub("-", "@", sexo_cor)) %>% 
  select(sexo_cor2) %>%  #selecionar variável de interesse
  head(10) # mostrar 10 primeiros

# lead() e lad() ----
x = 1:10
# uma defasagem
lag(x)
# duas defasagens
lag(x, 2)

# adiantar uma vez 
lead(x)

# adiantar duas vezes
lead(x, 2)

# criar uma série
df = tibble(a = rep(1:5, 3), 
            b = rnorm(15, 15, 10))

# lead e lag
df %>% 
  mutate(c = lead(b, 1), 
         d = lag(b, 2))

# lead e lag comd dados sociais
TO <- ds %>% 
  filter(uf == "11") %>% 
  select(ano:municipio, rdpc)

# exibir primeiras linhas
head(TO)

# lead
TO <- TO %>%  ungroup %>% 
  group_by(cod_ibge) %>% 
  mutate(lag_rdpc = lag(rdpc), 
         var_rdpc = (rdpc - lag_rdpc)/ lag_rdpc,
         var_rdpc_pec = paste(round(var_rdpc*100, 2), "%"))
tail(TO)
