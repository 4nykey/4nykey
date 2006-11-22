ADD_DEFINITIONS(-DMPP_DECODER -DFAST_MATH -DCVD_FASTLOG)
LINK_LIBRARIES(m)

# generate config.h
ADD_EXECUTABLE(cfg config)
ADD_CUSTOM_COMMAND(TARGET cfg POST_BUILD COMMAND ./cfg)

# optional features
IF(USE_ASM)
    ADD_DEFINITIONS(-DUSE_ASM)

    FIND_PROGRAM(NASM_EXECUTABLE nasm)
    SET(NASM_FLAGS -DUSE_FXCH -f elf)

    SET(ASM_OBJS)
    FOREACH(nas cpu_feat synthasm endianasm)
        SET(ASM_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/${nas}.nas)
        SET(ASM_OBJECT ${CMAKE_CURRENT_BINARY_DIR}/${nas}.o)
        SET(ASM_OBJS ${ASM_OBJS} ${ASM_OBJECT})
        ADD_CUSTOM_COMMAND(
            OUTPUT ${ASM_OBJECT}
            COMMAND ${NASM_EXECUTABLE}
            ARGS ${NASM_FLAGS} -o ${ASM_OBJECT} ${ASM_SOURCE}
            DEPENDS ${ASM_SOURCE})
    ENDFOREACH(nas)
ENDIF(USE_ASM)
IF(USE_ESD)
    ADD_DEFINITIONS(-DUSE_ESD_AUDIO)
ENDIF(USE_ESD)
IF(USE_OSS)
    ADD_DEFINITIONS(-DUSE_OSS_AUDIO)
ELSE(USE_OSS)
    ADD_DEFINITIONS(-DNO_DEV_AUDIO)
ENDIF(USE_OSS)

# mppdec target
ADD_EXECUTABLE(mppdec huffsv7 profile stderr tools
    decode http huffsv46 id3tag mppdec requant synth synthtab wave_out
    _setargv codetable_data codetable_dec codetable priority directory
    ${ASM_OBJS})

# extra libs
IF(USE_ESD)
    EXECUTE_PROCESS(COMMAND esd-config --libs OUTPUT_VARIABLE ESD_LIBS)
    TARGET_LINK_LIBRARIES(mppdec ${ESD_LIBS})
ENDIF(USE_ESD)

# replaygain target
ADD_DEFINITIONS(-DCD_SAMPLE_FREQ=44100)
ADD_EXECUTABLE(replaygain replaygain gain_analysis pipeopen stderr _setargv)

INSTALL(TARGETS mppdec replaygain RUNTIME DESTINATION bin)
