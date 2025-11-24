import pdfplumber
import pandas as pd

tables = []
i = 0

path_to_pdf = 'C:/Users/ryana/Documents/Github/2023-Tourist-Arrivals-Philippines/dataset/2023_Tourist_Arrivals_in_the_Philippines.pdf'

with pdfplumber.open(path_to_pdf) as pdf:
    for page in pdf.pages:
        table = page.extract_table({})

        if table:
            i += 1

            if i < 7:
                print('processed page/s:', i)

                for row in table[1:]:
                    tables.append(row)
            else:
                break


df = pd.DataFrame(tables, columns=['rank',
                                   'country',
                                   'january',
                                   'february',
                                   'march',
                                   'april',  
                                   'may',
                                   'june', 
                                   'july',
                                   'august',
                                   'september',
                                   'october',
                                   'total',
                                   'share'])
df.to_csv("/Users/ryana/Documents/Github/2023-Tourist-Arrivals-Philippines/dataset/2023_Tourist_Arrivals_in_the_Philippines.csv", index=False, encoding='utf-8')