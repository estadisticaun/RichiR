# Instalar librerías requeridas ----

install.packages(c("readxl", "tidyverse"))

# Librerías ----

library(tidyverse) 
library(readxl)  

# Importar datos ----

Fuente <- read_excel("Datos/Imagenes.xlsx", sheet = "Hoja1")

# Transformar datos ----

Datos <- Fuente %>% pivot_wider(names_from = VARIABLE, 
                                values_from = IMAGEN) %>% 
                                replace(is.na(.), 0) 



