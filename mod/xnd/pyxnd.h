/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2017-2018, plures
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


#ifndef PYXND_H
#define PYXND_H
#ifdef __cplusplus
extern "C" {
#endif


#include <Python.h>
#include <ndtypes.h>
#include <xnd.h>


/****************************************************************************/
/*                           MemoryBlock Object                             */
/****************************************************************************/

/* This object owns the memory that is shared by several xnd objects. It is
   never exposed to the Python level.

   The memory block is created by the primary xnd object on initialization.
   Sub-views, slices etc. share the memory block.

   PEP-3118 imports are supported.  At a later stage the mblock object will
   potentially need to communicate with Arrow or other formats in order
   to acquire and manage external memory blocks.
*/

/* Exposed here for the benefit of Numba. The API should not be regarded
   stable across versions. */

typedef struct {
    PyObject_HEAD
    PyObject *type;    /* type owner */
    xnd_master_t *xnd; /* memblock owner */
    Py_buffer *view;   /* PEP-3118 imports */
} MemoryBlockObject;


/****************************************************************************/
/*                                 xnd object                               */
/****************************************************************************/

/* Exposed here for the benefit of Numba. The API should not be regarded
   stable across versions. */

typedef struct {
    PyObject_HEAD
    MemoryBlockObject *mblock; /* owner of the primary type and memory block */
    PyObject *type;            /* owner of the current type */
    xnd_t xnd;                 /* typed view, does not own anything */
} XndObject;

#define TYPE_OWNER(v) (((XndObject *)v)->type)
#define XND(v) (&(((XndObject *)v)->xnd))
#define XND_INDEX(v) (((XndObject *)v)->xnd.index)
#define XND_TYPE(v) (((XndObject *)v)->xnd.type)
#define XND_PTR(v) (((XndObject *)v)->xnd.ptr)


/****************************************************************************/
/*                                Capsule API                               */
/****************************************************************************/

typedef struct {
  int (* const Xnd_CheckExact)(const PyObject *);
  int (* const Xnd_Check)(const PyObject *);
  const xnd_t *(* const CONST_XND)(const PyObject *);
  PyObject *(* const Xnd_EmptyFromType)(PyTypeObject *, const ndt_t *t, uint32_t flags);
  PyObject *(* const Xnd_ViewMoveNdt)(const PyObject *, ndt_t *t);
  PyObject *(* const Xnd_FromXnd)(PyTypeObject *, xnd_t *x);
  PyObject *(* const Xnd_Subscript)(const PyObject *self, const PyObject *key);
  PyObject *(* const Xnd_FromXndMoveType)(const PyObject *xnd, xnd_t *x);
  PyTypeObject *(* const Xnd_GetType)(void);
  PyObject *(* const Xnd_FromXndView)(xnd_view_t *x);
} XndAPI;

#ifndef _XND_SOURCE
static XndAPI *xnd_api;

#define Xnd_CheckExact(a) xnd_api->Xnd_CheckExact(a)
#define Xnd_Check(a) xnd_api->Xnd_Check(a)
#define CONST_XND(a) xnd_api->CONST_XND(a)
#define Xnd_EmptyFromType(a, b, c) xnd_api->Xnd_EmptyFromType(a, b, c)
#define Xnd_ViewMoveNdt(a, b) xnd_api->Xnd_ViewMoveNdt(a, b)
#define Xnd_FromXnd(a, b) xnd_api->Xnd_FromXnd(a, b)
#define Xnd_Subscript(a, b) xnd_api->Xnd_Subscript(a, b)
#define Xnd_FromXndMoveType(a, b) xnd_api->Xnd_FromXndMoveType(a, b)
#define Xnd_GetType() xnd_api->Xnd_GetType()
#define Xnd_FromXndView(a) xnd_api->Xnd_FromXndView(a)

static int
import_xnd(void)
{
    xnd_api = (void *)PyCapsule_Import("xnd._xnd._API", 0);
    if (xnd_api == NULL) {
        return -1;
    }

    return 0;
}
#endif

#ifdef __cplusplus
}
#endif

#endif /* PYXND_H */
