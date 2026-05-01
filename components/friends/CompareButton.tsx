'use client'

import { Swords } from 'lucide-react'
import { useRouter } from 'next/navigation'
import { useTrackerStore } from '@/store/useTrackerStore'
import { Button } from '@/components/ui/button'

export function CompareButton({ friendId, username }: { friendId: string; username: string }) {
  const router = useRouter()
  const setPendingHuntFriend = useTrackerStore(s => s.setPendingHuntFriend)

  return (
    <Button
      size="lg"
      variant="outline"
      className="gap-2"
      onClick={() => {
        setPendingHuntFriend({ id: friendId, username })
        router.push('/tracker')
      }}
    >
      <Swords className="h-4 w-4" />
      Comparer les collections
    </Button>
  )
}
