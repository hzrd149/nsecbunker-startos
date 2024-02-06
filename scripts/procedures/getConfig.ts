// To utilize the default config system built, this file is required. It defines the *structure* of the configuration file. These structured options display as changeable UI elements within the "Config" section of the service details page in the StartOS UI.

import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  relays: {
    name: "Listen Relays",
    description: "A list of relays to listen on",
    type: "list",
    subtype: "string",
    range: "[1, *)",
    default: ["wss://relay.damus.io", "wss://relay.nsecbunker.com"],
    spec: {},
  },
  "admin-npubs": {
    name: "Admin Users",
    description: "A list of npubs that are allowed to control the nsecbunker",
    type: "list",
    subtype: "string",
    range: "[1, *)",
    default: [],
    spec: {
      copyable: true,
      pattern: "npub1[a-zA-Z0-9]{58}",
      "pattern-description": "String must be an npub",
    },
  },
  notifyAdminsOnBoot: {
    name: "Notify admins on boot",
    description: "Send a DM to admins when nsecbunker starts",
    type: "boolean",
    default: true,
  },
  adminRelays: {
    name: "Admin Relays",
    description:
      "A list of relays used for admins to connect to the nsecbunker",
    type: "list",
    subtype: "string",
    range: "[1, *)",
    default: ["wss://relay.nsecbunker.com"],
    spec: {},
  },
});
