//
//  HAPPlatformFileHandle.c
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

#include "HAPPlatformFileHandle.h"

HAP_RESULT_USE_CHECK
HAPError HAPPlatformFileHandleRegister(
        HAPPlatformFileHandleRef* fileHandle_,
        int fileDescriptor,
        HAPPlatformFileHandleEvent interests,
        HAPPlatformFileHandleCallback callback,
        void* _Nullable context) {
    HAPPrecondition(fileHandle_);
    /*
    // Prepare fileHandle.
    HAPPlatformFileHandle* fileHandle = calloc(1, sizeof(HAPPlatformFileHandle));
    if (!fileHandle) {
        HAPLog(&logObject, "Cannot allocate more file handles.");
        *fileHandle_ = 0;
        return kHAPError_OutOfResources;
    }
    fileHandle->fileDescriptor = fileDescriptor;
    fileHandle->interests = interests;
    fileHandle->callback = callback;
    fileHandle->context = context;
    fileHandle->prevFileHandle = runLoop.fileHandles->prevFileHandle;
    fileHandle->nextFileHandle = runLoop.fileHandles;
    fileHandle->isAwaitingEvents = false;
    runLoop.fileHandles->prevFileHandle->nextFileHandle = fileHandle;
    runLoop.fileHandles->prevFileHandle = fileHandle;

    *fileHandle_ = (HAPPlatformFileHandleRef) fileHandle;
    */
    return kHAPError_None;
}

void HAPPlatformFileHandleDeregister(HAPPlatformFileHandleRef fileHandle_) {
    /*
    HAPPrecondition(fileHandle_);
    HAPPlatformFileHandle* fileHandle = (HAPPlatformFileHandle * _Nonnull) fileHandle_;

    HAPPrecondition(fileHandle->prevFileHandle);
    HAPPrecondition(fileHandle->nextFileHandle);

    if (fileHandle == runLoop.fileHandleCursor) {
        runLoop.fileHandleCursor = fileHandle->nextFileHandle;
    }

    fileHandle->prevFileHandle->nextFileHandle = fileHandle->nextFileHandle;
    fileHandle->nextFileHandle->prevFileHandle = fileHandle->prevFileHandle;

    fileHandle->fileDescriptor = -1;
    fileHandle->interests.isReadyForReading = false;
    fileHandle->interests.isReadyForWriting = false;
    fileHandle->interests.hasErrorConditionPending = false;
    fileHandle->callback = NULL;
    fileHandle->context = NULL;
    fileHandle->nextFileHandle = NULL;
    fileHandle->prevFileHandle = NULL;
    fileHandle->isAwaitingEvents = false;
    HAPPlatformFreeSafe(fileHandle);
    */
}

void HAPPlatformFileHandleUpdateInterests(
        HAPPlatformFileHandleRef fileHandle,
        HAPPlatformFileHandleEvent interests,
        HAPPlatformFileHandleCallback callback,
        void* _Nullable context)
{
    
}
