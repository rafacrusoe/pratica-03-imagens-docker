import pandas as pd


data = {
    "Nome": ["Ana", "Bruno", "Carlos"],
    "Idade": [28, 34, 29],
    "Cidade": ["Sao Paulo", "Rio de Janeiro", "Belo Horizonte"],
}

df = pd.DataFrame(data)

print("DataFrame criado no container com a imagem ideal:")
print(df)

