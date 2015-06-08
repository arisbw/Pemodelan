import pandas as pd
import scipy as sp
import os
import matplotlib.pyplot as plt
import numpy as np
from collections import OrderedDict
from sklearn.linear_model import Ridge
from sklearn.preprocessing import PolynomialFeatures
from sklearn.pipeline import make_pipeline

os.chdir('D:\\PythonAsik\\') #ubah sesuai dengan letak file data_kendaraan.csv
data_kendaraan = pd.read_csv('data_kendaraan.csv')
def plot_gambar(stream, day):
    data_hari = data_kendaraan.loc[data_kendaraan.hari==day]
    arus = data_hari[stream]
    jam  = data_hari['jam']
    print jam
    eq1 = sp.interpolate.interp1d(jam, arus, kind='linear')
    eq2 = sp.interpolate.interp1d(jam, arus, kind='quadratic')
    eq3 = sp.interpolate.interp1d(jam, arus, kind='cubic')
    model = make_pipeline(PolynomialFeatures(5), Ridge())
    #model.fit(jam, arus)
    #eq4 = model.predict(jam)
    jam_new = np.linspace(0, 16, 90)
    plt.plot(jam,arus,'o',jam, eq1(jam),'-' ,jam_new, eq2(jam_new),'--',jam_new, eq3(jam_new),'.') #,jam, arus, eq4(jam), 'o')
    plt.legend(['Data', 'Linear', 'Quadratic','Cubic'], loc='best')
    if stream=="arus1":
        stream="arus 1"
    elif stream == "arus2":
        stream="arus 2"
    elif stream == "arus3":
        stream="arus 3"
    elif stream == "arus4":
        stream="arus 4"
    if day=='senin_kamis':
        day="senin sampai kamis"
    quote = "Grafik fungsi interpolasi "+ stream+ " pada hari "+ day
    plt.title(quote)
    plt.xlabel("Jam")
    plt.ylabel("Jumlah kendaraan")
    plt.show()
    
plot_gambar('arus1', 'senin_kamis')
    
list_hari  = data_kendaraan['hari']
list_hari  = list(OrderedDict.fromkeys(list_hari))
list_arus  = list(data_kendaraan.columns.values)[2:]
def cek_macet(hijau1, hijau2, hijau3):
    for hari in list_hari:
        data_hari = data_kendaraan.loc[data_kendaraan.hari==hari]
        for arus in list_arus:
            break