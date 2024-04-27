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


#ifndef GUMATH_EXT_H
#define GUMATH_EXT_H


#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
  #include <cstdint>
#else
  #include <stdint.h>
#endif

#include <ndtypes.h>
#include <xnd.h>
#include <gumath.h>

GM_API int gm_init_example_kernels(gm_tbl_t *tbl, ndt_context_t *ctx);
GM_API int gm_init_graph_kernels(gm_tbl_t *tbl, ndt_context_t *ctx);
GM_API int gm_init_quaternion_kernels(gm_tbl_t *tbl, ndt_context_t *ctx);
GM_API int gm_init_pdist_kernels(gm_tbl_t *tbl, ndt_context_t *ctx);

#ifdef __cplusplus
} /* END extern "C" */
#endif


#endif /* GUMATH_EXT_H */
