# See here for test to make sure this works: https://gist.github.com/evaryont/6786915

jar xvf jce_policy-8.zip
# Copy them to an alternate location and use update-alternatives so they don't
# get overwritten when Java is updated
mkdir -p /usr/lib/jvm-private/java-1.8.0-oracle.x86_64/jce/unrestricted
/bin/cp -f UnlimitedJCEPolicyJDK8/local_policy.jar /usr/lib/jvm-private/java-1.8.0-oracle.x86_64/jce/unrestricted
/bin/cp -f UnlimitedJCEPolicyJDK8/US_export_policy.jar /usr/lib/jvm-private/java-1.8.0-oracle.x86_64/jce/unrestricted
