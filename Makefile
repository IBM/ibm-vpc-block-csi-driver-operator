all: build
.PHONY: all

# Include the library makefile
include $(addprefix ./vendor/github.com/openshift/build-machinery-go/make/, \
	golang.mk \
	targets/openshift/deps-gomod.mk \
	targets/openshift/images.mk \
	targets/openshift/bindata.mk \
)

# Run core verification and all self contained tests.
#
# Example:
#   make check
check: | verify test-unit
.PHONY: check

#IMAGE_REGISTRY?=icr.io/ibm
IMAGE_REGISTRY?=quay.io/ocs-roks-team

.PHONY: build-image
build-image: all
	docker build -t $(IMAGE_REGISTRY)/origin-ibm-vpc-block-csi-driver-operator -f Dockerfile .
	docker push $(IMAGE_REGISTRY)/origin-ibm-vpc-block-csi-driver-operator:latest


clean:
	$(RM) origin-ibm-vpc-block-csi-driver-operator
#	$(RM) ibm-vpc-block-csi-driver-operator
.PHONY: clean

GO_TEST_PACKAGES :=./pkg/... ./cmd/...

# Run e2e tests. Requires openshift-tests in $PATH.
#
# Example:
#   make test-e2e
test-e2e:
	hack/e2e.sh

.PHONY: test-e2e
