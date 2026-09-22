import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from sklearn.linear_model import LinearRegression


print("Todas as bibliotecas foram importadas com sucesso!")

# As referencias abaixo deixam explicito que os imports foram validados.
print(
    "Versoes:",
    f"numpy={np.__version__}",
    f"pandas={pd.__version__}",
    f"matplotlib={plt.matplotlib.__version__}",
    f"seaborn={sns.__version__}",
    f"modelo={LinearRegression.__name__}",
)

