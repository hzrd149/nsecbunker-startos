import { types as T, util } from "../deps.ts";

function noProperties(): T.ResultType<T.Properties> {
  return {
    result: {
      version: 2,
      data: {
        "Not Ready": {
          type: "string",
          value:
            "Could not find properties. nsecbunker might still be starting...",
          description: "Properties could not be found",
          qr: false,
          copyable: false,
          masked: false,
        },
      },
    },
  };
}

export const properties: T.ExpectedExports.properties = async (effects) => {
  if (
    (await util.exists(effects, {
      volumeId: "main",
      path: "/connection.txt",
    })) === false
  ) {
    return noProperties();
  }

  const connection = await effects.readFile({
    volumeId: "main",
    path: "/connection.txt",
  });

  return {
    result: {
      version: 2,
      data: {
        "Connection String": {
          type: "string",
          value: connection,
          description: "Use this link to login to nsecbunker from the Admin UI",
          copyable: true,
          qr: false,
          masked: false,
        },
      },
    },
  };
};
