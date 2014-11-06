message("Testhelper called with args '${ARGS}'")
# Crazy: remove " from string boundaries
STRING(REGEX REPLACE "^\"|\"$" "" ARGS ${ARGS})
SET(FILEINPUT )
if(INFILE)
    SET(FILEINPUT INPUT_FILE ${INFILE})
    message("Runnig cmd line equivalent '${CMD} ${ARGS} < ${INFILE}'")
else()
    message("Runnig cmd line equivalent '${CMD} ${ARGS}'")
endif()
# separate arguments into a list that can be used with execute_process
separate_arguments(ARGS)
execute_process(COMMAND ${CMD} ${ARGS}
    ${FILEINPUT} 
    OUTPUT_VARIABLE CMD_RESULT 
    RESULT_VARIABLE CMD_RETCODE
    ERROR_VARIABLE CMD_ERR)
if(CMD_RETCODE LESS 0)   
    message(FATAL_ERROR "Test binary ${CMD} failed: CMD_RETCODE=${CMD_RETCODE}, CMD_ERR=${CMD_ERR}")
endif()
message(STATUS "--------------------------------------\nResult of test ${CMD}:${CMD_RETCODE}\n${CMD_RESULT}")