
const defaultConf = {
  concurrency: 1,
  hostname: "127.0.0.1",
  port1: 50000,
  port2: 50001,
  browserInitTimeout: 240000,
  reporter: [
      {
          "name": "list"
      },
      {
          "name": "xunit",
          "output": "results/results.xml"
      }
],
  color: true,
  disableScreenshots: false,
  screenshots: {
      takeOnFails: true,
      path: "results/artifacts/",
      fullPage: true,
      pathPattern: "${FIXTURE}-${TEST}-screenshot-${FILE_INDEX}.png"
},
}

function getBooleanValueFromVarEnv(varEnv) {
  return varEnv === 'true' || varEnv === true
}

function getNumberValueFromVarEnv(varEnv) {
  return parseInt(varEnv, 10)
}

function getTimeout(varEnv) {
  return getNumberValueFromVarEnv(varEnv || process.env.TESTCAFE_TIMEOUT || 60000)
}

const browsers = process.env.BROWSER || 'chrome'
const debugMode = getBooleanValueFromVarEnv(process.env.TESTCAFE_DEBUG_MODE || false)
const debugOnFail = getBooleanValueFromVarEnv(process.env.TESTCAFE_DEBUG_ON_FAIL || false)
const skipJsErrors = getBooleanValueFromVarEnv(process.env.TESTCAFE_SKIP_JS_ERROR || true)
const skipUncaughtErrors = getBooleanValueFromVarEnv(process.env.TESTCAFE_SKIP_UNCAUGHT_ERRORS || true)
const disablePageCaching = getBooleanValueFromVarEnv(process.env.TESTCAFE_DISABLE_PAGE_CACHING || true)
const stopOnFirstFail = getBooleanValueFromVarEnv(process.env.TESTCAFE_STOP_ON_FIRST_FAIL || false)
const failedOnly = getBooleanValueFromVarEnv(process.env.TESTCAFE_VIDEO_OPTION_FAILED_ONLY || true)
const assertionTimeout = getTimeout(process.env.TESTCAFE_ASSERTION_TIMEOUT)
const selectorTimeout = getTimeout(process.env.TESTCAFE_SELECTOR_TIMEOUT)
const pageLoadTimeout = getTimeout(process.env.TESTCAFE_PAGE_LOAD_TIMEOUT)
const speed = getNumberValueFromVarEnv(process.env.TESTCAFE_SPEED || 1)

const customConf = {
  browsers,
  debugMode,
  debugOnFail,
  skipJsErrors,
  skipUncaughtErrors,
  disablePageCaching,
  assertionTimeout,
  selectorTimeout,
  pageLoadTimeout,
  speed,
  stopOnFirstFail
}

const noVideoConf = {}
const videoConf = getBooleanValueFromVarEnv(process.env.TESTCAFE_RECORD_VIDEO) ? {
  videoPath: "results/artifacts/",
  videoOptions: {
      singleFile: false,
      failedOnly,
      pathPattern: "${FIXTURE}-${TEST}-video-${FILE_INDEX}.mp4"
  },
  videoEncodingOptions: {
      r:"20",
      aspect:"4:3"
  }
} : noVideoConf

module.exports = {...defaultConf, ...customConf, ...videoConf}
