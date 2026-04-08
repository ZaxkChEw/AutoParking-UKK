from django.apps import AppConfig
import os

class ParkirConfig(AppConfig):
    name = 'parkir'

    def ready(self):
        if os.environ.get('RUN_MAIN') == 'true':
            from . import mqtt_client
            mqtt_client.start_mqtt()
            print("[APP] MQTT start dipanggil SEKALI")
        else:
            print("[APP] Skip MQTT start (RUN_MAIN bukan true)")