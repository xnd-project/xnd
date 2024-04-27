/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2017-2024, plures
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#ifndef PYNDTYPES_H
#define PYNDTYPES_H
#ifdef __cplusplus
extern "C" {
#endif


#include <Python.h>
#include <ndtypes.h>


/****************************************************************************/
/*                                 ndt object                               */
/****************************************************************************/

/* Exposed here for the benefit of Numba. The API should not be regarded
   stable across versions. */

typedef struct {
    PyObject_HEAD
    Py_hash_t hash;
    const ndt_t *ndt;
} NdtObject;

#define NDT(v) (((NdtObject *)v)->ndt)


/****************************************************************************/
/*                                Capsule API                               */
/****************************************************************************/

typedef struct {
  int (* const Ndt_CheckExact)(const PyObject *);
  int (* const Ndt_Check)(const PyObject *);
  PyObject *(* const Ndt_SetError)(ndt_context_t *);
  PyObject *(* const Ndt_FromType)(const ndt_t *);
  PyObject *(* const Ndt_FromObject)(PyObject *);
  PyObject *(* const Ndt_FromOffsetsAndDtype)(PyObject *offsets, bool *opt, const ndt_t *dtype);
} NdtypesAPI;

#ifndef _NDTYPES_SOURCE
static const NdtypesAPI *ndtypes_api;

#define Ndt_CheckExact(a) ndtypes_api->Ndt_CheckExact(a)
#define Ndt_Check(a) ndtypes_api->Ndt_Check(a)
#define Ndt_SetError(a) ndtypes_api->Ndt_SetError(a)
#define Ndt_FromType(a) ndtypes_api->Ndt_FromType(a)
#define Ndt_FromObject(a) ndtypes_api->Ndt_FromObject(a)
#define Ndt_FromOffsetsAndDtype(a, b, c) ndtypes_api->Ndt_FromOffsetsAndDtype(a, b, c)

static int
import_ndtypes(void)
{
    ndtypes_api = (NdtypesAPI *)PyCapsule_Import("ndtypes._ndtypes._API", 0);
    if (ndtypes_api == NULL) {
        return -1;
    }

    return 0;
}
#endif

#ifdef __cplusplus
}
#endif

#endif /* PYNDTYPES_H */
