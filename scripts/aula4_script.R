# Aula 4 - Manipulação de Dados

# carregar biblioteca
library(tidyverse)

# fixar diretório
setwd("C:/curso_r_enap/dados/")

# listar arquivos
list.files()

# ler arquivo dados sociais - separador decimal é vírgula
dados_sociais <- ("dados_sociais.csv", dec = ",")

dados_sociais <- read_csv2("dados_sociais.csv", 
                           locale = locale(encoding = "Latin1"))

# estrutura do arquivo
str(dados_sociais)

#######################
# começando pelo pipe #
#######################
x = c(1.555, 2.555, 3.555, 4.555)

# tirar o log de x 
log(x)

# mesma coisa com o pipe
x %>% log()

# vc pode ir além!
x %>% log() %>% round(2) # UAU!

#############################
# Principais comandos dplyr #
#############################

# filter ----
# filtra apenas anos 2000 ou 2010
dados_sociais %>% 
  filter( ano == 2000 | ano == 2010)

# filtar pop acima da média
dados_sociais %>%
  filter(pop > mean(pop))

# select ----
# selecionar algumas colunas
dados_sociais %>% 
  select(ano, uf, tx_analf_15m )

# seleciona conjunto de colunas
dados_sociais %>% 
  select(ano:municipio)

# seleciona todas variáveis, exceto município
dados_sociais %>% 
  select(-municipio)

# seleciona as variáveis uf e tx_analf_15m
minha_selecao <- c("uf", "tx_analf_15m")
dados_sociais %>% 
  select(minha_selecao)

# seleciona variaveis que comecam com esp
dados_sociais %>%
  select(starts_with("esp"))

# seleciona variaveis que terminam com o
dados_sociais %>%
  select(ends_with("o"))

# reordena grupos de variaveis
dados_sociais %>% 
  select(cod_ibge:rdpc, ano:uf)

# reordena apenas 1 variável.
dados_sociais %>% 
  select(cod_ibge, everything())

# renomear
dados_sociais %>% 
  rename(ANO = ano, 
         UF = uf)

# arrange ----
# ordena pela menor pop
dados_sociais %>% 
  arrange(pop)
# ordena pelo maior ano e menor pop
dados_sociais %>% 
  arrange(-ano, pop)

# mostra apenas os 5 primeiros
dados_sociais %>% 
  arrange(-ano, pop) %>%
  head(5)

# mostra apenas os 5 últimos
dados_sociais %>% 
  arrange(-ano, pop) %>%
  tail(5)

# mutate: cria novas colunas no banco ----
dados_sociais %>% 
  mutate(renda_total = rdpc * pop,
         log_pop = log(pop))

# transmute: cria apenas novas colunas
dados_sociais %>% 
  transmute(renda_total = rdpc * pop,
         log_pop = log(pop))

# summarise ----
# média esp_vida por ano
dados_sociais %>% 
  group_by(ano) %>% # agrupa por ano
  summarise(media = mean(esp_vida))

# média esp_vida por ano e uf
dados_sociais %>% 
  group_by(ano, uf) %>% # agrupa por ano
  summarise(media = mean(esp_vida))

##########################
# join: melhor que procv #
##########################

# dois data.frames para exemplo 
df1 <- tibble(letras = letters[1:8], X = 1:8)
df2 <- tibble(letras = letters[5:12], Y = 1:8)

# inner join
# apenas os dados em comum
inner_join(df1, df2)
# idêntico, mas preferível!
inner_join(df1, df2, by = "letras")

# junção total
df_na <- full_join(df1, df2, by = "letras")

# junção à esquerda
left_join(df1, df2, by = "letras")

# junção à direita
right_join(df1, df2, by = "letras")

# dados não coincidentes
anti_join(df1, df2, by ="letras")
anti_join(df2, df1, by ="letras")

###################
# outros comandos #
###################

# baixar fies sample
fies <-  read_csv2("fies_sample.csv")

# quantos distintos
fies %>% 
  select(CO_CONTRATO_FIES) %>%
  n_distinct()
  
# duplicados
fies %>% 
  select(CO_CONTRATO_FIES) %>%
  duplicated()


# quantos distintos e duplicados
fies %>% 
  select(CO_CONTRATO_FIES) %>%
  summarise(distintos = n_distinct(CO_CONTRATO_FIES),
            duplicados = sum(duplicated(CO_CONTRATO_FIES)))

# tirar repetidos do banco
fies_dist <- fies_sub %>%
  distinct(CO_CONTRATO_FIES, .keep_all = TRUE)

## round ----
# gerar uma distribuição normal aleatória
x <- rnorm(10, 5, 1)
# Arredondar
round(x)
# Arredondar com duas casas decimais
round(x, digits = 2)
# Ou ainda...
round(x, 2)

# ceiling - arredondar para cima
ceiling(x)

# floor - arredondar para baixo
floor(x)

# any ----
# algum elemento do banco "df_na" é NA?
any(is.na(df_na))
# A coluna letras do banco "df_na" é NA?
any(is.na(df_na$letras))
# A coluna letras do banco "df_na" contém a letra E?
any(df_na == "E")

# cut ----
d <- tibble( id = seq(1:100),
             idade = round(rnorm(100, mean = 35, 15)))
d$idade_cut <- cut(d$idade, seq(0,100, 5))

# paste ----
# irmãos Peixoto
irmaos <- c("Edgar", "Edclésia", "Edmar", "Edésia", "Edésio")

# como colocar os sobrenomes?
paste(irmaos, "Peixoto")

# paste0 - sem espaço
paste0(irmaos, "Peixoto")



# ifelse(): seleção condicional ----
tib <- tibble( x = seq(0L, 30L, 2L), y = LETTERS[1:16])
tib$x1 <- ifelse(tib$x >15, "Maior do que 10", "Menor do que 10")
tib$x2 <- ifelse(tib$x >15, tib$x^2, tib$x)

# como fazer isso com dplyr?

# bind ----

# bind_rows - juntar linhas

# extrair linhas específicas
um  <-  dados_sociais[1:4, ]
dois <- dados_sociais[7011:7014, ]

# ligar em um novo objeto 
meu_bind <- bind_rows(um, dois)

# bind_cols - juntar colunas

# extrair colunas
um   <- dados_sociais[ , 3 ]
dois <- dados_sociais[ , 8 ]

# ligar em um novo objeto 
meu_bind2 <- bind_cols(um, dois)

# NAs ----
# Data frame com NAs
df_na <- tibble( letras = LETTERS[1:10],
                 idade =  c( seq(25L, 40L, 5L), NA,
                             NA, 32L, rep(NA, 3)))

# é possível saber se um vetor é NA
is.na(df_na)
# Também é possível remover esses valores
na.omit(df_na)

# replace_na
# Substituindo NAs por números
replace_na(df_na, list(idade = 0))

# Substituindo NAs por textos
replace_na(df_na, list(idade = "Idade não informada"))

#############
# lubridade #
#############

# ano, mês e dia sem separador
ymd("20180131")
# mês, dia e ano com separador "-"
mdy("01-31-2018")
# dia, mês e ano com separador "/"
dmy("31/01/2018")

# criar um vetor de datas
datas<- ymd(c("20180131", "20170225", "20160512"))
# quais os anos
year(datas)
# quais os meses
months(datas); month(datas)
# dias
day(datas)
# dia da semana
wday(datas)


