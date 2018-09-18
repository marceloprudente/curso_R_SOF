# Manipulação de dados com *dplyr*

## limpar ambiente global
rm(list = ls())

## Primeiro passo: fixar diretório
setwd("C:/curso_r/dados")

## Segundo passo: utilizar pacotes
library(tidyverse)
library(data.table) # para fread()

## Terceiro passo: carregar dados sociais
ds <- fread("dados_sociais.csv", 
            dec = ',')

## Quarto passo passo: analisar os dados
glimpse(ds)
summary(ds)

# Verbos do *dplyr*----

## filter: selecionar linhas

## apenas ano 2000
ds_2000 <- filter(ds, ano == 2000)
## apenas municipio de aracaju
ds_ara <- filter(ds, 
                        municipio == "ARACAJU")
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

# select() ----

# selecionar 3 colunas
ds_select <- select(ds, ano, uf, rdpc)

head(ds_select)

# retirar colunas
ds_select2 <- select(ds, -rdpc, - pop)
head(ds_select2)

# com vetor
nome <- c("ano", "uf", "pop")
ds_select3<- select(ds, nome)
head(ds_select3)

# selecionar primeras
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
## PIPE - seu melhor amigo ----
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


