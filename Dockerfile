FROM centos:centos7.3.1611

LABEL name="Total Recall CentOS 7 Base Image"


# https://github.com/CentOS/sig-cloud-instance-images/issues/41
RUN mkdir -p /etc/selinux/targeted/contexts ; echo '<busconfig><selinux></selinux></busconfig>' > /etc/selinux/targeted/contexts/dbus_contexts

RUN yum -y install epel-release && yum -y install cronie initscripts polkit python-pip python-devel git libselinux-python libffi-devel openssl-devel gcc net-tools && \
    pip install --upgrade pip && pip install setuptools==21.0.0 ansible==2.3.1.0 && \
    curl -s -L https://www.opscode.com/chef/install.sh | bash -s -- -v latest
    
CMD env GEM_HOME=/tmp/verifier GEM_PATH=/tmp/verifier GEM_CACHE=/tmp/verifier/gems/cache /opt/chef/embedded/bin/gem install thor busser busser-serverspec serverspec bundler && \
    gem install test-kitchen -v 1.8.0 kitchen-docker -v 2.4.0 kitchen-ansible -v 0.45.4 && \
    rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime && localedef -c -i en_US -f UTF-8 en_US.UTF-8 && localedef -c -i de_AT -f UTF--8 de_AT.UTF-8 && \
    systemctl enable crond.service && \
    chown -R kitchen:kitchen /tmp/verifier 
