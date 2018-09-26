# PNADC com R

# carregar pacotes
library(PNADcIBGE) # baixa pnadc
library(survey) # para analise de survey
library(srvyr) # survey tidyr

# diretório
setwd("C:/curso_r/dados/PNADC")

# listar arquivos
list.files()

# baixar dados
pnadc <- read_pnadc("PNADC_022018.txt", 
                    "Input_PNADC_trimestral.txt")

# incluir rótulos
pnadc <- pnadc_labeller(pnadc, 
                        "dicionario_das_variaveis_PNAD_Continua_microdados.xls")


# desenho de survey
pnadc <- pnadc_design(pnadc)

# transformar em tbl_svy
pnadc <- as_survey(pnadc)

# população estimada do Brasil em 2017
pnadc %>% 
  mutate(one = 1) %>% 
  summarise(pop_brasil = survey_total(one))

# população estimada do Brasil por regiao em 2015
pop_reg <- pnadc %>%
  mutate(one = 1, 
         regiao = substr(UPA, 1, 1)) %>% 
  group_by(regiao)%>%
  summarize(pop_brasil = survey_total(one))

# rendimento por sexo: rendimento é numerico
head(pnadc$variables$V2007)
pnadc %>%
  group_by(V2007)%>%
  summarize(rendimento = survey_mean(VD4020, na.rm = TRUE))

# percentual de analfabetos
analf <- pnadc %>% 
  mutate(regiao = substr(UPA, 1, 1)) %>% 
  group_by(regiao, V3001) %>% 
  summarise(perc_analfabetos = survey_mean( na.rm = TRUE))

# rendimento por faixa etária
source("C:/curso_r/funcoes/age_cat.R")

renda <- pnadc %>%
  mutate(fx_idade = age.cat(V2009, upper = 90)) %>% 
  group_by(fx_idade)%>%
  summarise(perc_por_idade = survey_mean(, na.rm = TRUE),
            rendimento = survey_mean(VD4020, na.rm = TRUE))

renda2 <- pnadc %>%
  mutate(fx_renda = age.cat(VD4020, upper = 15000, by = 1000),
         one = 1) %>% 
  group_by(fx_renda)%>%
  summarise(perc_por_renda = survey_mean(, na.rm = TRUE),
            total = survey_total(one, na.rm = TRUE))

# rendimento por sexo
pnadc %>%
  group_by(V2007)%>%
  summarize(rendimento = survey_median(VD4020, na.rm = TRUE))

# rendimento entre os maiores de 30 e menores de 40
pnadc %>%
  filter(V2007>= 30 & V2007 <=40 )%>%
  summarize(rendimento = survey_median(VD4020, na.rm = TRUE))

# distribuição da renda por quantis
pnadc %>%
  summarise(rendimento = 
              survey_quantile(VD4020, c(0.25, 0.5, 0.75),
                              na.rm = TRUE, covmat = TRUE))

pnadc <- pnadc  %>% 
  mutate(regiao = as.factor(substr(UPA, 1, 1)))

# número e percentual de pessoas com mais de 15 anos
# analfabetos
analfabetos_uf <- pnadc %>% 
  filter(V2009 >=15) %>%
  group_by(UF, V3001)%>%
  summarise(analf = survey_total( na.rm = T), 
            analf_perc = survey_mean(na.rm = T))

# gráfico 1
analfabetos_uf %>% 
  filter(V3001 == "Não") %>% 
  ggplot(aes(x = reorder(UF, analf_perc), 
             y = analf_perc * 100)) +
  geom_col(fill = "blue", color = "red") +
  coord_flip() +
  labs( x = "", 
        y = "% analfabetos", 
        title = "% analfabetos maiores de 15 anos") +
  scale_y_continuous(breaks = seq(1, 20, 2)) +
  theme_bw()

# gráfico 2
analfabetos_uf %>% 
  ggplot(aes(x = reorder(UF, analf_perc), 
             y = analf_perc * 100,
             fill = V3001)) +
  geom_col() +
  coord_flip()


# 

# VD4020 - renda
# V2007 - sexo
svyttest(VD4020 ~ V2007, subset(pnadc, VD4008 == levels(VD4008)[3]))


pnadc %>% 
  group_by(VD4008, V2007) %>% 
  summarise(s = survey_mean(VD4020, na.rm = TRUE))

# o  ~ separa a variável dependente das independentes
modeloLin <- svyglm(VD4020 ~ VD3001 + V2010 + 
                      V2009 + V2007, pnadc)
summary(modeloLin)

# criando variaveis regressao logistica
pnadc <- pnadc %>% 
  mutate(regiao = substr(UPA, 1, 1),
         graduacao = ifelse(VD3001 == "Superior completo", 1, 0))

# modelo logístico
modelo_glm <- svyglm(graduacao ~ V2007 + V2010 + regiao, 
                     subset(pnadc, V2009 >=  18) , 
       family = "binomial")

# Concentração de Renda  ----
library(convey)
pnadc <- convey_prep(pnadc)

# gini renda
giniHab <- svygini(~VD4020, pnadc, na.rm  =  TRUE)
giniHab

# gini regiao
gini_regiao <- svyby(~VD4020, by = ~ regiao, 
                     dadosPNADc, svygini, na.rm  =  TRUE)
gini_regiao

# gini renda uf
giniUF <- svyby(~VD4020, by = ~UF, 
                dadosPNADc, svygini, na.rm  =  TRUE)
giniUF
