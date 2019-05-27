import numpy as np

from django.shortcuts import render

from .models import CrymeClassifier
from .utils import build_view_box


models = CrymeClassifier.objects.load_models()


def dashboard_view(request):
    longitude = 34.066426
    latitude = -118.471124

    feature_vectors = np.array([[longitude, latitude, time] for time in range(0, 1440, 60)])

    # build charting data
    charting_data = {}
    for model in models:
        percentage_scaled_positive_prediction_vector = models[model].predict_proba(feature_vectors)[:, 1] * 100
        charting_data[model.target] = {
            'values': percentage_scaled_positive_prediction_vector.tolist(),
            'max': round(percentage_scaled_positive_prediction_vector.max(), 4) * 1.1
        }

    charting_data['max'] = max([charting_data[model_target]['max'] for model_target in charting_data])

    # build real-time risk estimates
    real_time_risk_ests = []
    for model in models:
        est_pos_prob, risk_rating = model.predict_rt_positive(longitude, latitude)
        real_time_risk_ests.append({
            'name': model.crime_name,
            'risk': round(est_pos_prob * 100, 2),
            'rating': risk_rating
        })
    real_time_risk_ests = sorted(real_time_risk_ests, key=lambda k: k['risk'], reverse=True)

    context = {
        'charting_data': charting_data,
        'risk_ests_row_1': real_time_risk_ests[:4],
        'risk_ests_row_2': real_time_risk_ests[4:8],
        'view_box': build_view_box(longitude, latitude)
    }
    print(real_time_risk_ests)
    return render(request, 'dashboard.html', context)

