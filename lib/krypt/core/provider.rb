require 'ffi'

module Krypt
  module Provider
    extend FFI::Library

    ffi_lib FFI::CURRENT_PROCESS

    attach_function :krypt_provider_get_default, [], :pointer

    callback :fp_md_new_name, [:pointer, :string], :pointer
    callback :fp_md_new_oid, [:pointer, :string], :pointer
    
    class ProviderInterface < FFI::Struct
      layout :name,           :string,
             :md_new_oid,     :fp_md_new_oid,
             :md_new_name,    :fp_md_new_name
    end

    class KryptMd < FFI::Struct
      layout :provider,         :pointer,
             :methods,          :pointer
    end

    callback :fp_md_reset, [:pointer], :int
    #callback :fp_md_update, [:pointer, :buffer_in, :size_t], :int
    callback :fp_md_update, [:pointer, :pointer, :size_t], :int
    callback :fp_md_final, [:pointer, :pointer, :pointer], :int
    callback :fp_md_digest, [:pointer, :pointer, :size_t, :pointer, :pointer], :int
    callback :fp_md_digest_length, [:pointer, :pointer], :int
    callback :fp_md_block_length, [:pointer, :pointer], :int
    callback :fp_md_name, [:pointer, :pointer], :int
    callback :fp_md_mark, [:pointer], :void
    callback :fp_md_free, [:pointer], :void

    class DigestInterface < FFI::Struct
      layout :md_reset,         :fp_md_reset,
             :md_update,        :fp_md_update,
             :md_final,         :fp_md_final,
             :md_digest,        :fp_md_digest,
             :md_digest_length, :fp_md_digest_length,
             :md_block_length,  :fp_md_block_length,
             :md_name,          :fp_md_name,
             :md_mark,          :fp_md_mark,
             :md_free,          :fp_md_free
    end

    DEFAULT_PROVIDER = ProviderInterface.new(krypt_provider_get_default)

    module LibC
      extend FFI::Library

      ffi_lib FFI::Library::LIBC

      attach_function :malloc, [:size_t], :pointer
      attach_function :free, [:pointer], :void
      attach_function :memcpy, [:pointer, :pointer, :size_t], :void
    end
  end
end
