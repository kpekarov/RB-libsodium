#tag Class
Protected Class SigningKey
Inherits libsodium.KeyPair
	#tag Method, Flags = &h0
		 Shared Function Derive(PrivateKeyData As MemoryBlock) As libsodium.PKI.SigningKey
		  If PrivateKeyData.Size <> crypto_sign_SECRETKEYBYTES Then Raise New SodiumException(ERR_SIZE_MISMATCH)
		  Dim priv As New SecureMemoryBlock(crypto_sign_SECRETKEYBYTES)
		  Dim pub As New SecureMemoryBlock(crypto_sign_PUBLICKEYBYTES)
		  priv.StringValue(0, priv.Size) = PrivateKeyData
		  
		  If crypto_sign_ed25519_sk_to_pk(pub.TruePtr, priv.TruePtr) = 0 Then
		    pub.ProtectionLevel = libsodium.ProtectionLevel.NoAccess
		    priv.ProtectionLevel = libsodium.ProtectionLevel.NoAccess
		    Return New SigningKey(priv, pub)
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DeriveSeed() As MemoryBlock
		  Dim seed As New MemoryBlock(crypto_sign_SEEDBYTES)
		  If crypto_sign_ed25519_sk_to_seed(seed, Me.PrivateKey) = 0 Then Return seed
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		 Shared Function Generate(Optional SeedData As MemoryBlock) As libsodium.PKI.SigningKey
		  Dim pub As New SecureMemoryBlock(crypto_sign_PUBLICKEYBYTES)
		  Dim priv As New SecureMemoryBlock(crypto_sign_SECRETKEYBYTES)
		  If SeedData = Nil Then
		    If crypto_sign_keypair(pub.TruePtr, priv.TruePtr) = -1 Then Return Nil
		  Else
		    If SeedData.Size <> crypto_sign_SEEDBYTES Then Raise New SodiumException(ERR_SIZE_MISMATCH)
		    If crypto_sign_seed_keypair(pub.TruePtr, priv.TruePtr, SeedData) = -1 Then Return Nil
		  End If
		  Dim ret As New SigningKey(priv, pub)
		  pub.ProtectionLevel = libsodium.ProtectionLevel.NoAccess
		  priv.ProtectionLevel = libsodium.ProtectionLevel.NoAccess
		  
		  Return ret
		End Function
	#tag EndMethod


End Class
#tag EndClass