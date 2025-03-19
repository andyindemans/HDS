from flask import Flask, jsonify, render_template
import docker
import itertools
from os import getenv


app = Flask(__name__)
client = docker.from_env()

debug = int(getenv("DEBUG", 0)) == 1


def get_graph_data():
    containers = client.containers.list(all=True)
    nodes = []
    edges = []

    service_types = {
        "internal": {
            "services": ["traefik", "dozzle", "dns", "nextcloud", "db", "files", "redis"],
            "color": "lightblue"
        },
        "external": {
            "services": ["paperless", "jellyfin"],
            "color": "orange"
        },
        "monitoring": {
            "services": ["grafana", "prometheus", "node-exporter", "cadvisor"],
            "color": "yellow"
        },
        "frontend": {
            "services": ["jvv-app", "nodegraph"],
            "color": "lightgreen"
        }
    }
    
    for service_type, details in service_types.items():
        type_node = {
            "id": service_type,
            "label": service_type,
            "color": "purple",  # Color for service type nodes
        }
        nodes.append(type_node)

        for service in details["services"]:
            service_container = next((container for container in containers if service in container.name), None)
            
            service_node = {
                "id": service,
                "label": service,
                "color": details["color"] if service_container and service_container.status == "running" else "red",
            }
            nodes.append(service_node)
            
            # Only create edge if service_container is found
            if service_container:
                edges.append({
                    "from": service_type,
                    "to": service,
                    "color": {"color": "#a0a0a0" if service_container.status == "running" else "red"},
                    "dashes": service_container.status != "running",
                    "smooth": False
                })

    return {"nodes": nodes, "edges": edges}

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/graph_data")
def graph_data():
    data = get_graph_data()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
