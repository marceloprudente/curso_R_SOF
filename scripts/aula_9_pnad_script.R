# Baixando pacotes necessários
  
  
## Instalando o pacote lodown

# instalar e utilizar pacote httr
install.packages(httr);  library(httr)

# reorganizar configuração para baixar pacote 
set_config(config(ssl_verifypeer = 0L))

# instalar e utilizar rcpp
install.packages("Rcpp"); library(Rcpp)

# devtools - para baixar do github
library(devtools)

# instalar lodown
install_github( "ajdamico/lodown" , dependencies = TRUE )

## Instalando os pacotes survey e srvyr

# instalar pacote survey
install.packages("survey")
library(survey)

# instalar e utilizar pacote srvyr
install.packages("srvyr")
library("srvyr")
```
# BAIXAR DADOS DA PNAD
## Criando catálogo dos arguivos a serem baixados
# utilizar pacote lodown
library(lodown)

# Pesquisa Nacional de Amostra de Domicílios
pnad_cat <-
  get_catalog( "pnad" ,
               output_dir = file.path( path.expand( "~" ) , "PNAD" ))

# Cria um catálogo com todas os dados disponíveis
meu.path <- "C:/PNADC"
pnad_cat <-
  get_catalog( "pnad" ,
               output_dir = meu.path )

## Baixando os dados
- Depois de criado o catálogo, vizualize.
View(pnad_cat)

# Tirar um subconjunto dos dados
pnadc_cat <- pnad_cat%>% 
  filter(year == 2015)

# baixar pnad
lodown( "pnad" , pnad_cat )

## Ler o arquivo da PNAD já salvo
# Diretório dos arquivos
setwd(meu.path)
# Listar arquivos
list.files()
# readr
library(readr)
# baixar pnad
pnadc_df <- read_rds("2015 main")


## PNAD: lendo os arquivos

# Depois de baixados 
pnad_cat <- pnad_cat %>% filter(year == 2015)

# Ler variáveis
pnad <- read_rds(pnad_cat$output_filename)

# Estrutura do banco
str(pnad)

# PNAD - manipulação dos dados

## Transformar em numéricas
str(pnad)

# transformar as variáveis em numericas
pnad <- pnad %>% 
  mutate_if(is.character, as.numeric)

## Recodificar algumas variáveis PNAD

# função age cat
source("C:/curso_r_enap/funcoes/age_cat.R")

# criar novas variáveis
pnad <- pnad %>%
  mutate(
    # cria faixa de idades
    fx_idade = age.cat(v8005, upper = 80, by = 5) ,
    # criar uma variável para determinar quem são os adolescentes
    adolescentes = as.numeric( v8005 > 12 & v8005 < 20 ) ,
    # se o indivíduo trabalha antes dos 13 anos
    trab_antes_treze = as.numeric( v9892 < 13 ))

## Exemplo: criar variável situação da família

require(knitr)
require(kableExtra)
library(tibble)

## Exemplo: situação da família: passo 1

# Recodificar variáveis
pnad <- pnad %>% 
  # identifica o domicilio 
  mutate(domicilio = factor(paste0(v0101, v0102, v0103))) %>%
  group_by(domicilio) %>% 
  # identifica quem tem conjuge no domicilio
  mutate(tem_conjuge =as.numeric(any(v0401 == 2)))%>%
  group_by(domicilio, tem_conjuge)%>%
  # identifica quem tem filhos
  mutate(tem_filhos = ifelse(any(v0401 == 3), 7, 0))
```

## Exemplo: situação da família: passo 2

pnad <- pnad %>% group_by(domicilio)%>%
  mutate(sexo_conjuge= ifelse(tem_conjuge ==1, 6, 
                              v0302),
         sit_fam = (sexo_conjuge + tem_filhos + tem_conjuge))

## Exemplo: situação da família: passo 3

pnad$sit_fam <- recode(pnad$sit_fam, 
                       "2" = "Homem Sozinho", 
                       "4" = "Mulher Sozinha",
                       "9" = "Pai com filhos",
                       "11" = "Mãe com filhos",
                       "14" = "Casal com filhos", 
                       "7" =  "Casal sem filhos")

####################################
# Preparando o survey para análise #
####################################

##  Analisando surveys: pacotes
library(survey)

## Pré-estratificação da PNAD

prestratified_design <-
svydesign(
# upa
id = ~ v4618 ,
# estrato
strata = ~ v4617 ,
data = pnad,
# v4610 - inv fracao amostral
weights = ~ pre_wgt ,
nest = TRUE
)

## Pós-estratificação: computar
pop_types <- 
data.frame( 
v4609 = unique( pnad$v4609 ) , 
Freq = unique( pnad$v4609 ))

pnad_design <- 
postStratify( 
design = prestratified_design ,
strata = ~ v4609 ,
population = pop_types
)

rm( pnad, prestratified_design ) ; gc()


## PNAD_DESIGN

class(pnad_design)

# transformar em tbl_svy
pnad_design <- as_survey(pnad_design)

# classe
class(pnad_design)

# opção para ajustar o cálculo da variância
options( survey.lonely.psu = "adjust" )


# Análise da PNAD
## pacote svryr

## Análises: totais survey_total()
```
# população estimada do Brasil em 2015
pnad_design %>% 
summarize(pop_brasil = survey_total(one))

# população estimadad do Brasil por regiao em 2015
pnad_design %>% 
group_by(region)%>%
summarize(pop_brasil = survey_total(one))
```

## Análises: média survey_mean()

# rendimento por sexo
pnad_design %>%
group_by(v0302)%>%
summarize(rendimento = survey_mean(v4718, na.rm = TRUE))

# rendimento por faixa etária
pnad_design %>%
group_by(fx_idade)%>%
summarize(rendimento = survey_mean(v4718, na.rm = TRUE))

## Análises mediana survey_median()

# rendimento por sexo
pnad_design %>%
group_by(v0302)%>%
summarize(rendimento = survey_median(v4718, na.rm = TRUE))

# rendimento por faixa etária
pnad_design %>%
filter(v8005>10)%>%
group_by(fx_idade)%>%
summarize(rendimento = survey_median(v4718, na.rm = TRUE))

## Análises dos quantis survey_quantile()

# distribuição da renda por grupos
pnad_design %>%
summarize(rendimento = 
survey_quantile(v4718, c(0.25, 0.5, 0.75),
na.rm = TRUE, covmat = TRUE))

# rendimento por faixa etária
pnad_design %>%
summarize(rendimento = 
survey_quantile(v4718, seq(0.1, 1, 0.1),
na.rm = TRUE))

```

## Exercícios

- Resolver exercícios.

