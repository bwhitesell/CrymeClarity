# Generated by Django 2.1.7 on 2019-05-13 00:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('crime', '0002_auto_20190512_2348'),
    ]

    operations = [
        migrations.AlterField(
            model_name='crimeincident',
            name='date_occ',
            field=models.DateTimeField(),
        ),
    ]