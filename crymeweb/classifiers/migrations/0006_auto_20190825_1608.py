# Generated by Django 2.1.7 on 2019-08-25 16:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('classifiers', '0005_auto_20190825_1543'),
    ]

    operations = [
        migrations.AlterField(
            model_name='modelperformance',
            name='day',
            field=models.DateField(),
        ),
    ]
