from django.http import JsonResponse
import numpy as np
import pickle
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from scipy.stats import mode
from django.shortcuts import render

import warnings
warnings.filterwarnings("ignore", message="X does not have valid feature names")


def replace_underscore(value):
    return value.replace('_', ' ')
def accueil(request):
    return render(request, 'Api_app/accueil.html')


def predict_disease(request):
    df = pd.read_csv('Api_app/static/Api_app/Training.csv')
    df = df.drop(columns='Unnamed: 133')
    label_encoder = LabelEncoder()
    df['prognosis_encoded'] = label_encoder.fit_transform(df['prognosis'])
    X = df.drop(['prognosis', 'prognosis_encoded'], axis=1)
    X = X.apply(pd.to_numeric, errors='coerce')
    features = X.columns

    if request.method == 'POST':
        patient_symptoms = request.POST.getlist('symptoms')

        # Charger le modèle à partir du fichier
        with open('Api_app/static/Api_app/model.pkl','rb') as file:
            model = pickle.load(file)
        with open('Api_app/static/Api_app/clf.pkl','rb') as file:
            clf = pickle.load(file)
        with open('Api_app/static/Api_app/rdm.pkl','rb') as file:
            rdm = pickle.load(file)

        patient_data = {}
        for feature in features:
            if feature in patient_symptoms:
                patient_data[feature] = 1
            else:
                patient_data[feature] = 0

        input_data = np.array(list(patient_data.values())).reshape(1, -1)

        model_preds = model.predict(input_data)
        rdm_preds = rdm.predict(input_data)
        clf_preds = clf.predict(input_data)


        maladie = [mode([i, j, k], keepdims=True)[0][0] for i, j, k in zip(rdm_preds, clf_preds, model_preds)]

        result = ''
        for i, encoded_value in enumerate(df['prognosis_encoded']):
            if encoded_value == maladie[0]:
                result = df['prognosis'][i]

        return JsonResponse({'result': result})

    context = {
        'features': features,
        'replace_underscore': replace_underscore,
    }

    return render(request, 'Api_app/index.html', context)
