# Stage 1: Build
#tag::build[]
FROM eclipse-temurin:21.0.4_7-jre-jammy@sha256:870aae69d4521fdaf26e952f8026f75b37cb721e6302d4d4d7100f6b09823057 as build
ENV BUILDDIR=/tmp/build
RUN mkdir -p ${BUILDDIR}
COPY ./ ${BUILDDIR}/
WORKDIR ${BUILDDIR}/
# chmod required because Azure Agent user has no privileges
RUN chmod -R 777 ${BUILDDIR} && ./gradlew bootJar
#end::build[]
#tag::run[]
# Stage 2: App
FROM eclipse-temurin:21.0.4_7-jre-jammy@sha256:870aae69d4521fdaf26e952f8026f75b37cb721e6302d4d4d7100f6b09823057 as app
WORKDIR /opt
ARG VERSION
ENV VERSION=$VERSION
ENV BUILDDIR=/tmp/build
COPY --from=build ${BUILDDIR}/build/libs/service-$VERSION.jar .
ENTRYPOINT ["sh", "-c", "java -jar ./service-$VERSION.jar"]
#end::run[]
