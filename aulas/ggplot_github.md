Untitled
================
Marcelo Prudente
20 de setembro de 2018

Tipos de gráficos

Tipos de gráficos
-----------------

-   **Histogramas**: representa a distribuição de dados numéricos contínuos.
    -   **densidade**
-   **Caixas**: representa a variação de categorias de dados numéricos.
-   **Barras**: ótimo para sumarizar dados categóricos.
-   **Dispersão**: aponta a relação entre duas variáveis contínuas.

Baixar dados para analise
-------------------------

``` r
library(readr)
library(ggplot2)
dados_sociais <-read_csv2("C:/curso_r/dados/dados_sociais.csv", 
                          locale = locale(encoding = "LATIN1"))
# criar variável para regiao
dados_sociais$regiao <- substr(dados_sociais$uf, 1, 1)
```

Sistema
-------

-   os 4 gráficos com a base do sistema:

``` r
# Histograma
hist(dados_sociais$esp_vida)
```

<img src="figuras_ggplot/unnamed-chunk-2-1.png" width="912" />

``` r
# Diagrama de Caixas
with(dados_sociais, boxplot(esp_vida  ~factor(uf)))
```

<img src="figuras_ggplot/unnamed-chunk-2-2.png" width="912" />

``` r
# Barras
p <- table(dados_sociais$uf)
barplot(p)
```

<img src="figuras_ggplot/unnamed-chunk-2-3.png" width="912" />

``` r
# Dispersão
with(dados_sociais, plot(esp_vida, log(rdpc)))
```

<img src="figuras_ggplot/unnamed-chunk-2-4.png" width="912" />

-   Tente no seu pc

ggplot2
=======

Porque ggplot2?
---------------

-   É uma alternativa mais elegante aos gráficos com:
    -   cores automáticas para os gráficos
    -   temas pré-estabelecidos (como no excel)
    -   facilidade de customização
    -   [**outros:** *veja aqui*](https://github.com/tidyverse/ggplot2/wiki/Why-use-ggplot2)
-   Em resumo, é possível mexer em todos os aspectos do gráfico

Como funciona o ggplot2
-----------------------

-   O ggplot2 aplica a gramática de gráficos de [*Wilkinson*](https://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448)
-   A ideia central é criar os gráficos em camadas com os seguintes componentes:
    -   banco de dados
    -   coordenadas (x , y) - estética
    -   camadas geométricas

abordagens do ggplot2
---------------------

-   Há duas abordagens:
    -   **qplot()** - gráficos rápidos (*quick plot*)
    -   **ggplot** - gráficos mais elaborados

qplot(): vizualizações rápida
-----------------------------

-   É possível plotar quase tudo com o **qplot**. Entretanto, você não alcançará todo o potencial do ggplot.
-   **qplot()** é o mesmo que *quick plot* e segue a lógica de camadas. Veja!

![qplot](C:/curso_r_enap/imagens/qplot2)

-   Veja que é possível criar histogramas e gráficos de caixas com facilidade,

``` r
# Histograma
qplot(esp_vida, data = dados_sociais)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

<img src="figuras_ggplot/unnamed-chunk-3-1.png" width="912" />

``` r
# Boxplot
qplot(x = factor(uf),y = esp_vida, 
      data = dados_sociais, geom = "boxplot")
```

<img src="figuras_ggplot/unnamed-chunk-3-2.png)

qplot() em ação
---------------

-   Do mesmo modo, gráficos de barras e de dispersão

``` r
# Barplot
p <- table(dados_sociais$uf)
qplot(x = factor(uf), data = dados_sociais, 
      geom = "bar")

# Dispersão
qplot(x = esp_vida, y = log(rdpc), data = dados_sociais, 
      geom = "point") 
```

ggplot()
--------

-   O gráfico rápido tem grande funcionalidade para observarmos relações de modo fácil.
-   Porém, é possível extrair mais dos gráficos.
-   A forma básica de expressar o ggplot é a seguinte:

![ggplot](C:/curso_r_enap/imagens/ggplot)

ggplot(): entendendo os argumentos
----------------------------------

-   Ao mapear os dados e as coordenadas, o ggplot cria um quadro em branco.

``` r
g <- ggplot(dados_sociais, aes(esp_vida, log(rdpc)) )
g
```

<img src="figuras_ggplot/unnamed-chunk-5-1.png" width="912" /> 

- O que você vê?

ggplot(): especificando a camada geométrica
-------------------------------------------

-   Isso ocorre pois é necessário especificar a camada geométrica.

``` r
g + geom_point()
```

<img src="figuras_ggplot/unnamed-chunk-6-1.png" width="912" />

Em outras palavras, especificamos que os elementos do gráfico devem ser pontos. Também seria possível pedir linhas. Veja o que ocorre:

``` r
g + geom_line()
```

<img src="figuras_ggplot/unnamed-chunk-7-1.png" width="912" />

ggplot(): indo além dos argumentos
----------------------------------

Quando especificamos uma camada geométrica, podemos alterar os seus atributos internos, a exemplo da cor.

``` r
g + geom_point(colour = "red")
```

<img src="figuras_ggplot/unnamed-chunk-8-1.png" width="912" />

Ainda, é possível especificar ou a cor, o tamanho dos pontos de acordo com faixas populacionais e o formato dos pontos.

``` r
g + geom_point(aes(size = pop), colour = "red", shape = 2 )
```

<img src="figuras_ggplot/unnamed-chunk-9-1.png" width="912" />

Observe o quão versátil pode ser a criação de gráficos: os pontos podem variar de acordo com o ano em que cada valor foi obervado. Observe também que é possível impelir o ano a ser um *factor* diretamente na fórmula.

``` r
g + geom_point(aes(colour = factor(ano), 
                   shape = factor(ano))) 
```

<img src="figuras_ggplot/unnamed-chunk-10-1.png)

ggplot(): preciso saber de todos os verbos e todas as formas geométricas?
-------------------------------------------------------------------------

-   De jeito nenhum! O site do *tidyverse* traz todos os exemplos necessários para fazer um bom gráfico.
    -   <http://ggplot2.tidyverse.org/reference/>
    -   <https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf>
-   Porém, é importante saber o tipo de variável com que irá trabalhar.

-   Na prática, há diversos sites com inúmero exemplos de tabulação de dados que podem ser facilmente replicados. O site abaixo traz 50 exemplos de gráficos tabuláveis ggplot.
    -   \*<http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html*>

Histogramas
-----------

Voltando aos histogramas, a formatação segue a mesma lógica apresentada anteriormente.

``` r
ggplot(dados_sociais, aes(x = esp_vida)) +
  geom_histogram(color = "blue", fill = "green")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

<img src="figuras_ggplot/unnamed-chunk-11-1.png" width="912" />

Note o belo gráfico abaixo! Adicionamos mais uma camada ao histrograma, uma linha com a contagem dos casos, e controlamos as cores, o tamanho e o tipo da linha.

``` r
ggplot(dados_sociais, aes(x = esp_vida)) +
  geom_histogram(color = "red", fill = "black") +
  geom_freqpoly( size = 1.5, color = "green", lty = 2)
```

<img src="figuras_ggplot/unnamed-chunk-12-1.png" width="912" />

Densidade
---------

Os gráficos de densidade são versões mais suavizadas do histograma. Observe o código e tente entender o que foi feito.

``` r
ggplot(dados_sociais, aes(x = esp_vida, color = factor(ano))) +
  geom_density(aes(fill = factor(ano), alpha = 1))
```

<img src="figuras_ggplot/unnamed-chunk-13-1.png)

stat\_summary()
---------------

O ggplot oferece uma forma de summarizar algumas medidas de tendência central dos dados já no gráfico com o comando *stat\_summary()*.

Por exemplo, se for necessário plotar um gráfico com a média da renda per capita por Estado é possível fazer por :

``` r
# usar dplyr
library(dplyr)
rdpc_uf <- dados_sociais %>% 
  group_by(uf) %>%
  summarise(rdpc = mean(rdpc))

ggplot(rdpc_uf, aes(factor(uf), rdpc)) + 
  stat_sum( geom = "bar")
```

<img src="figuras_ggplot/unnamed-chunk-14-1.png" width="912" />

Ou mesmo diretamente no gráfico por meio do **stat\_summary().**

``` r
dados_sociais %>%
  ggplot(aes(factor(uf), rdpc)) +
  stat_summary(fun.y = "mean", geom = "bar")
```

<img src="figuras_ggplot/unnamed-chunk-15-1.png" width="912" />

Veja que o *stat\_summary* solicita qual a função transformará o valor de y e qual o *geom* será utilizado. Mais prático, não?

Sumarizar por grupo
-------------------

-   É possível utilizar o **stat\_summary()** para criar gráficos por grupos. Abaixo, o gráfico especifica a média por ano da variável renda per capita

``` r
# criar plot de base
dados_sociais %>% 
  ggplot(aes(ano, rdpc, color = factor(regiao)) ) + 
  stat_summary(fun.y = "mean", geom = "line") 
```

<img src="figuras_ggplot/unnamed-chunk-16-1.png" width="912" />

Barras por grupo
----------------

-   Observe que o **stat\_summary()** permite versatilidade

``` r
g4 <- dados_sociais%>% 
ggplot(aes(regiao, tx_analf_15m, fill = as.factor(ano)))+ 
stat_summary(fun.y = "mean", 
             geom = "bar", position = "dodge") 
g4
```

<img src="figuras_ggplot/unnamed-chunk-17-1.png" width="60%" style="display: block; margin: auto;" />

Subgráficos
===========

facet()
-------

-   Ainda, é possível criar subgráficos por grupos - por exemplo, um gráfico para cada região.

``` r
# criar plot de base
p <- dados_sociais %>%
  ggplot(aes(esp_vida, rdpc)) + 
  geom_point( color = "steelblue") 
# facet em um mesma grade de imagem
p + facet_grid(. ~ regiao)
```

<img src="figuras_ggplot/unnamed-chunk-18-1.png" width="912" />

facet()
-------

-   Também, é possível criar subgráficos por grupos com mais grades.

``` r
# facet wrap
p + facet_wrap( ~ regiao, ncol = 2)
```

<img src="figuras_ggplot/unnamed-chunk-19-1.png" width="912" />

Camadas de ajuste
=================

Títulos
-------

-   Veja como é possível modificar os títulos dos eixos e legendas

``` r
# elaborar gráfico
graf <- dados_sociais %>% 
  ggplot(aes(esp_vida, rdpc, color = factor(ano)) ) + 
  geom_point(shape = 1) 

# aplicar títulos
graf <- graf + 
  labs( title = "Renda x Esperança de Vida", 
        caption = "Fonte: IBGE. Elaboração própria",
        x = "Esperança de Vida", 
        y = "Renda per capita", 
        color = "Anos")
graf
```

<img src="figuras_ggplot/unnamed-chunk-20-1.png" style="display: block; margin: auto;" />

Ajustar as escalas
------------------

Facilmente as coordenadas são alteradas

``` r
graf <- graf + 
  scale_x_continuous(breaks = seq(50, 80, 5),
                     labels = function(x) paste(x, "anos")) +
  scale_y_continuous(breaks = seq(0, 3000, 250), 
                     labels = function(x) paste("R$", x)) +
  scale_color_manual(values = c("darkolivegreen1", "steelblue", "brown2"))

graf
```

<img src="figuras_ggplot/unnamed-chunk-21-1.png" style="display: block; margin: auto;" />

Temas
=====

theme
-----

-   Por fim, o **ggplot()** permite modificar os temas dos gráficos.
    -   Há alguns temas prontos, mas é possível editar o seu próprio: **help(theme)**

``` r
graf +  theme_minimal()
```

<img src="figuras_ggplot/unnamed-chunk-22-1.png" style="display: block; margin: auto;" />

Crie seu próprio tema
---------------------

Outra forma de lidar com os dados

``` r
graf +  theme(
        plot.title = element_text(hjust=0.5, face="bold"),
        plot.background=element_rect(fill="white"),
        panel.background=element_rect(fill="white"),
        panel.grid.minor= element_line(color = "gray60"),
        panel.grid.major.y=element_line(color = "gray60"),
        panel.grid.major.x=element_line(color = "gray60"),
        axis.ticks=element_blank(),
        legend.position="bottom")
```

<img src="figuras_ggplot/unnamed-chunk-23-1.png" style="display: block; margin: auto;" />
