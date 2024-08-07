# Stage 1: Build
#tag::build[]
FROM eclipse-temurin:17-jre-jammy@sha256:cafe19b793d3c300ad0ab5b75a491b98b7dcacfae5f0be655ced2eb590b835c7 as build
ENV BUILDDIR=/tmp/build
RUN mkdir -p ${BUILDDIR}
COPY ./ ${BUILDDIR}/
WORKDIR ${BUILDDIR}/
# chmod required because Azure Agent user has no privileges
RUN chmod -R 777 ${BUILDDIR} && ./gradlew bootJar
#end::build[]
#tag::run[]
# Stage 2: App
FROM eclipse-temurin:17-jre-jammy@sha256:cafe19b793d3c300ad0ab5b75a491b98b7dcacfae5f0be655ced2eb590b835c7 as app
WORKDIR /opt
ARG VERSION
ENV VERSION=$VERSION
ENV BUILDDIR=/tmp/build
COPY --from=build ${BUILDDIR}/build/libs/service-$VERSION.jar .
ENTRYPOINT ["sh", "-c", "java -jar ./service-$VERSION.jar"]
#end::run[]
