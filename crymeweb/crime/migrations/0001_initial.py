# Generated by Django 2.1.7 on 2019-05-12 23:38

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CrimeIncident',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('_id', models.CharField(max_length=100, unique=True)),
                ('crm_cd', models.IntegerField()),
                ('crm_cd_desc', models.TextField()),
                ('date_occ', models.DateField()),
                ('time_occ', models.IntegerField()),
                ('premis_desc', models.TextField()),
                ('longitude', models.FloatField()),
                ('latitude', models.FloatField()),
            ],
        ),
    ]
