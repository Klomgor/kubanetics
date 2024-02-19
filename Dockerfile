FROM docker.io/library/alpine:3.19.1
ARG TARGETPLATFORM

COPY --from=registry.k8s.io/kubectl:v1.29.2 /bin/kubectl /usr/local/bin/kubectl
COPY --from=ghcr.io/siderolabs/talosctl:v1.6.4 /talosctl /usr/local/bin/talosctl

ENV PATH="${PATH}:/root/.krew/bin"

RUN apk add --no-cache ca-certificates bash catatonit curl git jq util-linux yq
RUN curl -fsSL "https://i.jpillora.com/kubernetes-sigs/krew!!?as=krew&type=script" | bash
RUN krew install cnpg \
    && kubectl cnpg version

WORKDIR /app
COPY ./scripts .

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]