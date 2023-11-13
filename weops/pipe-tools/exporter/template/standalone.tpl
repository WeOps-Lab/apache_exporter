apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: apache-exporter-{{VERSION}}
  namespace: apache
spec:
  serviceName: apache-exporter-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: apache-exporter-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for exporter (ie, exporter -f <pattern>)
            pattern = "exporter"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: apache-exporter-standalone-{{VERSION}}
        exporter_object: apache
        object_mode: standalone
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      containers:
      - name: apache-exporter
        image: registry-svc:25000/library/apache-exporter:latest
        imagePullPolicy: Always
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          -
        env:
          - name: ES_USERNAME
            value: weops
          - name: ES_PASSWORD
            value: Weops@123
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 500m
            memory: 500Mi
        ports:
        - containerPort: 9114

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: apache-exporter-{{VERSION}}
  name: apache-exporter-{{VERSION}}
  namespace: apache
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9117"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 9117
    protocol: TCP
    targetPort: 9117
  selector:
    app: apache-exporter-{{VERSION}}
