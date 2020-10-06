import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";


const config = new pulumi.Config();
const project = config.require("project");
const namePrefix = config.require("name_prefix");
const region = config.require("region")

// Create a GCP resource (Storage Bucket)
const vpc = new gcp.compute.Network(`${namePrefix}-vpc`, {
    autoCreateSubnetworks: false,
    project: project,
    routingMode: "REGIONAL",
})

const publicSubnet = new gcp.compute.Subnetwork(`${namePrefix}-public-subnet`, {
    ipCidrRange: "172.0.0.0/20",
    network: vpc.selfLink,
    region: region,
    project: project,
    privateIpGoogleAccess: true,
})

const vpcRouter = new gcp.compute.Router(`${namePrefix}-router`, {
    network: vpc.selfLink,
    project: project,
    region: region,
})

const privateSubnet = new gcp.compute.Subnetwork(`${namePrefix}-private-subnet`, {
    ipCidrRange: "172.2.0.0/20",
    network: vpc.selfLink,
    region: region,
    project: project,
    privateIpGoogleAccess: true,
})

const vpcNat = new gcp.compute.RouterNat(`${namePrefix}-nat`, {
    project: project,
    region: region,
    router: vpcRouter.name,
    natIpAllocateOption: "AUTO_ONLY",

    sourceSubnetworkIpRangesToNat: "LIST_OF_SUBNETWORKS",
    subnetworks: [{
        name: publicSubnet.selfLink,
        sourceIpRangesToNats: ["ALL_IP_RANGES"],
    }],
})

const publicAllowAllInbound = new gcp.compute.Firewall(`${namePrefix}-public-allow-ingress`, {
    project: project,
    network: vpc.selfLink,
    targetTags: ["public"],
    direction: "INGRESS",
    sourceRanges: ["0.0.0.0/0"],

    allows: [{
        protocol: "all",
    }]
})

const privateAllowAllNetworkInbound = new gcp.compute.Firewall(namePrefix + "-private-allow-ingress", {
    project: project,
    network: vpc.selfLink,
    targetTags: ["private"],
    direction: "INGRESS",
    sourceRanges: [
        privateSubnet.ipCidrRange,
        publicSubnet.ipCidrRange
    ],
    allows: [{
        protocol: "all",
    }]
})
